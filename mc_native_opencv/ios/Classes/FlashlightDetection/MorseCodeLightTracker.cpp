#include "MorseCodeLightTracker.h"
#include <deque>
#include <opencv2/core/mat.hpp>
#include <opencv2/opencv.hpp>
#include <vector>

bool doRectsOverlap(const cv::Rect &rect1, const cv::Rect &rect2) {
  return (rect1 & rect2).area() > 0;
}

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
  cv::Mat thresh;
  // cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
  cv::threshold(thresh, thresh, 240, 255, cv::THRESH_BINARY);

  std::vector<std::vector<cv::Point>> contours;
  cv::findContours(thresh, contours, cv::RETR_EXTERNAL,
                   cv::CHAIN_APPROX_SIMPLE);

  std::vector<LightSource> lightSources;
  lightSources.reserve(MAX_LIGHT_SOURCES);

  for (const auto &contour : contours) {
    double area = cv::contourArea(contour);
    if (area < 100)
      continue;
    cv::Rect boundingBox = cv::boundingRect(contour);
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
  cv::Rect centerROI((downscaled.cols - cropWidth) / 2,
                     (downscaled.rows - cropHeight) / 2, cropWidth, cropHeight);

  cv::Mat cropped = downscaled(centerROI);

  std::vector<LightSource> lightSources = detectLightSources(cropped);

  return detectLightSources(cropped);
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

std::vector<MorseSignal> MorseCodeLightTracker::processFrame(
    const std::vector<LightSource> &detectedLights, long long timestamp) {
  std::vector<LightSource> currentSources;
  std::vector<MorseSignal> signalsToSend;

  bool trackedLightFound = false;
  if (!history.empty()) {
    auto &lastSources = history.back();
    for (auto &src : lastSources) {
      bool found = false;
      for (const auto &newLight : detectedLights) {
        if (doRectsOverlap(src.boundingBox, newLight.boundingBox)) {
          if (src.isOn != newLight.isOn) {
            src.toggleCount++;
            src.toggleHistory.push_back(!src.isOn);
          }
          src.isOn = newLight.isOn;
          found = true;
          src.age = 0;
          if (src.toggleCount > 6) {
            if (!trackingLight) {
              trackingLight = true;
              trackedLightID = src.id;
              for (int i = 0; i < src.toggleHistory.size(); i++) {
                signalsToSend.push_back(
                    {src.toggleHistory.at(i), timestamps.at(i)});
              }
              trackedLightFound = true;
            } else if (src.id == trackedLightID) {
              signalsToSend.push_back(
                  {src.toggleHistory.back(), timestamps.back()});
              trackedLightFound = true;
            }
          }
          break;
        }
      }
      if (!found) {
        src.age++;
        if (src.age <= MAX_AGE) {
          currentSources.push_back(src);
        }
      }
    }
    if (trackedLightFound == false) {
      trackingLight = false;
      trackedLightID = -1;
    }
  }
  currentSources.insert(currentSources.end(), detectedLights.begin(),
                        detectedLights.end());

  if (timestamps.size() >= maxSize) {
    timestamps.pop_front();
  }
  timestamps.emplace_back(std::move(timestamp));
  addFrame(std::move(currentSources));

  return signalsToSend;
}

std::vector<MorseSignal> MorseCodeLightTracker::updateLights(uint8_t* bytes, int width, int height, long long timestamp) {
    cv::Mat image(height, width, cv::COLOR_BGR2GRAY, bytes);

    std::vector<LightSource> detectedLights = extractLightSources(image, 0.4, 4, 6);
    std::vector<MorseSignal> signalsToSend = processFrame(detectedLights, timestamp);

    return signalsToSend;
}

bool MorseCodeLightTracker::testFunction(bool var) {
  if (var == false) {
    return true;
  }
  return false;
}