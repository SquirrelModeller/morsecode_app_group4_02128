#include "MorseCodeLightTracker.h"
#include <deque>
#include <opencv2/core/mat.hpp>
#include <opencv2/opencv.hpp>
#include <vector>

bool doRectsOverlap(const cv::Rect &rect1, const cv::Rect &rect2) {
  return (rect1 & rect2).area() > 0;
}

bool lastSignal = false;
int packageNum = 0;

LightSource::LightSource(bool isOn, const cv::Rect &boundingBox,
                         int toggleCount)
    : isOn(isOn), boundingBox(boundingBox), toggleCount(toggleCount) {
  static int nextID = 0;
  id = nextID++;
  toggleHistory.push_back(isOn);
}

MorseCodeLightTracker::MorseCodeLightTracker(size_t maxSize)
    : maxSize(maxSize) {}

std::vector<LightSource>
MorseCodeLightTracker::detectLightSources(cv::Mat &image) {
  cv::Mat gray, thresh;
  cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
  cv::threshold(gray, thresh, 240, 255, cv::THRESH_BINARY);

  std::vector<std::vector<cv::Point>> contours;
  cv::findContours(thresh, contours, cv::RETR_EXTERNAL,
                   cv::CHAIN_APPROX_SIMPLE);

  std::vector<LightSource> lightSources;
  lightSources.reserve(MAX_LIGHT_SOURCES);

  for (const auto &contour : contours) {
    double area = cv::contourArea(contour);
    if (area < 40)
      continue;
    cv::Rect boundingBox = cv::boundingRect(contour);
    boundingBox.height += boundingBox.height / 4;
    boundingBox.width += boundingBox.width / 4;
    lightSources.emplace_back(true, boundingBox);
    if (lightSources.size() == MAX_LIGHT_SOURCES)
      break;
  }
  return lightSources;
}

std::vector<LightSource> MorseCodeLightTracker::extractLightSources(
    cv::Mat &image, double scaleFactor, int cropColWidth, int cropRowHeight) {

  cv::Mat downscaled;
  cv::resize(image, downscaled, cv::Size(), scaleFactor, scaleFactor);

  int cropWidth = downscaled.cols / cropColWidth;
  int cropHeight = downscaled.rows / cropRowHeight;
  cv::Rect topHalfROI((downscaled.cols - cropWidth) / 2,
                      0,
                      cropWidth,
                      cropHeight / 1.8);

  cv::Mat cropped = downscaled(topHalfROI);

  std::vector<LightSource> lightSources = detectLightSources(cropped);

  return lightSources;
}

std::deque<bool> MorseCodeLightTracker::sendLightBuffer(LightSource &light) {
  return light.toggleHistory;
}
bool sendLight(LightSource &light) { return light.toggleHistory.back(); }

void MorseCodeLightTracker::addFrame(std::vector<LightSource> &&newSources) {
  if (history.size() >= maxSize) {
    history.pop_front();
  }
  history.emplace_back(std::move(newSources));
}

int MorseCodeLightTracker::nextID = 0;

int MorseCodeLightTracker::getNextID() { return nextID++; }

std::vector<MorseSignal>
MorseCodeLightTracker::processFrame(std::vector<LightSource> &detectedLights,
                                    long long timestamp) {
  if (history.empty()) {
    for (auto &light : detectedLights) {
      light.id = getNextID();
      light.toggleHistory.push_back(light.isOn);
    }
    timestamps.push_back(timestamp);
    history.push_back(detectedLights);
    return {};
  }
  timestamps.push_back(timestamp);

  std::vector<LightSource> currentSources;
  std::vector<MorseSignal> signalsToSend;
  std::unordered_map<int, bool> updated;
  const int toggleThreshold = 5;

  // Process overlaps and assign IDs
  for (auto &newSrc : detectedLights) {
    bool foundOverlap = false;

    for (auto &oldSrc : history.back()) {
      if (doRectsOverlap(newSrc.boundingBox, oldSrc.boundingBox)) {
        newSrc.id = oldSrc.id;
        foundOverlap = true;
        newSrc.toggleCount = oldSrc.toggleCount;
        newSrc.toggleHistory = oldSrc.toggleHistory;
        newSrc.hasExceededThreshold = oldSrc.hasExceededThreshold;
        if (newSrc.isOn != oldSrc.isOn) {
          newSrc.toggleCount++;
          newSrc.toggleHistory.push_back(newSrc.isOn);

          if (newSrc.toggleCount == toggleThreshold + 1) {
            if (trackedLightID == -1) { // Lock onto light
              trackedLightID = newSrc.id;
            }
            for (size_t i = 0; i < newSrc.toggleHistory.size(); ++i) {
                signalsToSend.push_back({newSrc.toggleHistory[i], timestamps[i]});
            }

            newSrc.hasExceededThreshold = true;
          } else if (newSrc.toggleCount > toggleThreshold && trackedLightID == oldSrc.id) {
            signalsToSend.push_back({newSrc.isOn, timestamps.back()});
          }
        }
        updated[oldSrc.id] = true;
        break;
      }
    }

    if (!foundOverlap) {
      newSrc.id = getNextID();
    }

    currentSources.push_back(newSrc);
  }

  // Update old sources that were not matched
  for (auto &oldSrc : history.back()) {
    if (!updated[oldSrc.id]) {
      oldSrc.age++;
      if (oldSrc.isOn) { // If the light was on and now is not detected
        oldSrc.isOn = false;
        oldSrc.toggleHistory.push_back(false);
        oldSrc.toggleCount++;
        // This is a very convoluted solution, and slows everything down, having it written twice.
        // I am doing it anyway. It sorta works.
        if (oldSrc.toggleCount == toggleThreshold + 1) {
          if (trackedLightID == -1) { // Lock onto light
            trackedLightID = oldSrc.id;
          }
          for (size_t i = 0; i < oldSrc.toggleHistory.size(); ++i) {
            signalsToSend.push_back({oldSrc.toggleHistory[i], timestamps[i]});
          }

          oldSrc.hasExceededThreshold = true;
        } else if (oldSrc.toggleCount > toggleThreshold && trackedLightID == oldSrc.id) {
          signalsToSend.push_back({false, timestamps.back()});
        }
      }
      if (oldSrc.age <= MAX_AGE) {
        currentSources.push_back(oldSrc);
      }
      if (oldSrc.age > MAX_AGE && trackedLightID == oldSrc.id) {
        trackedLightID = -1; // Release light
      }
    }
  }
  // Update history and timestamps
  if (history.size() >= maxSize) {
    history.pop_front();
    timestamps.pop_front();
  }
  history.push_back(currentSources);
  packageNum++;

  return signalsToSend;
}

std::vector<MorseSignal>
MorseCodeLightTracker::updateLights(cv::Mat &image, int width, int height,
                                    long long timestamp) {

  std::vector<LightSource> detectedLights =
      extractLightSources(image, 0.3, 1, 1);

  std::vector<MorseSignal> signalsToSend =
      processFrame(detectedLights, timestamp);

  return signalsToSend;
}

bool MorseCodeLightTracker::testFunction(bool var) {
  if (var == false) {
    return true;
  }
  return false;
}