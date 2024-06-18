#include <chrono>
#include <cstddef>
#include <deque>
#include <iostream>
#include <ostream>
#include <utility>
#include <vector>
#include <opencv2/opencv.hpp>

constexpr size_t MAX_LIGHT_SOURCES = 50;
constexpr int MAX_AGE = 5;

bool doRectsMatch(const cv::Rect &rect1, const cv::Rect &rect2) {
  return ((rect1 & rect2).area() > ((rect1.area() + rect2.area()) / 10));
}

bool doRectsOverlap(const cv::Rect &rect1, const cv::Rect &rect2) {
  return (rect1 & rect2).area() > 0;
}

struct LightSource {
public:
  bool isOn;
  cv::Rect boundingBox;
  int toggleCount = 0;
  int age = 0;
  static int nextID;
  int id;
  std::deque<bool> toggleHistory;

  LightSource(bool isOn, const cv::Rect &boundingBox, int toggleCount = 0)
      : isOn(isOn), boundingBox(boundingBox), toggleCount(toggleCount) {
        toggleHistory.push_back(isOn);
      }
};

int LightSource::nextID = 0;


cv::Point2f findPhoneFlashlight(const cv::Mat &image) {
  cv::Mat gray, thresh;
  cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
  cv::threshold(gray, thresh, 240, 255, cv::THRESH_BINARY);

  std::vector<std::vector<cv::Point>> contours;
  cv::findContours(thresh, contours, cv::RETR_EXTERNAL,
                   cv::CHAIN_APPROX_SIMPLE);

  cv::Point2f flashlightCenter;
  double maxBrightness = -1;
  for (const auto &contour : contours) {
    double area = cv::contourArea(contour);
    if (area < 100) {
      continue;
    }
    cv::Rect boundingBox = cv::boundingRect(contour);
    cv::Point2f center = (boundingBox.br() + boundingBox.tl()) * 0.5;

    cv::Mat mask = cv::Mat::zeros(thresh.size(), CV_8UC1);
    cv::drawContours(mask, contours, static_cast<int>(&contour - &contours[0]),
                     cv::Scalar(255), cv::FILLED);
    double meanBrightness = cv::mean(gray, mask)[0];

    if (meanBrightness > maxBrightness) {
      maxBrightness = meanBrightness;
      flashlightCenter = center;
    }
  }

  return flashlightCenter;
}



std::vector<LightSource> detectLightSources(cv::Mat &image) {
  cv::Mat thresh;
  // cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
  cv::threshold(thresh, thresh, 240, 255, cv::THRESH_BINARY);

  std::vector<std::vector<cv::Point>> contours;
  cv::findContours(thresh, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

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


std::vector<LightSource> extractLightSources(cv::Mat &image, double scaleFactor,
                                             int cropColWidth,
                                             int cropRowHeight) {

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

std::deque<bool> sendLightBuffer(LightSource &light) {
  return light.toggleHistory;
}
bool sendLight(LightSource &light) {
  return light.toggleHistory.back();
}

class FrameLightManager {
private:
  std::deque<std::vector<LightSource>> history;
  size_t maxSize;
  bool trackingLight = false;
  int trackedLightID = -1;
  

public:
  explicit FrameLightManager(size_t maxSize) : maxSize(maxSize) {}

  void addFrame(std::vector<LightSource> &&newSources) {
    if (history.size() >= maxSize) {
      history.pop_front();
    }
    history.emplace_back(std::move(newSources));
  }

  void processFrame(const std::vector<LightSource> &detectedLights) {
    std::vector<LightSource> currentSources;
    bool trackedLightFound = false;
    if (!history.empty()) {
      auto &lastSources = history.back();
      for (auto &src : lastSources) {
        bool found = false;
        for (const auto &newLight : detectedLights) {
          if (doRectsOverlap(src.boundingBox, newLight.boundingBox)) {
            if (src.isOn != newLight.isOn) {
              src.toggleCount++;
            }
            src.isOn = newLight.isOn;
            found = true;
            src.age = 0;
            if (src.toggleCount > 6) {
              if (!trackingLight) {
                trackingLight = true;
                trackedLightID = src.id;
                sendLightBuffer(src);
                trackedLightFound = true;
              } else if (src.id == trackedLightID) {
                sendLight(src);
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
    currentSources.insert(currentSources.end(), detectedLights.begin(), detectedLights.end());
    addFrame(std::move(currentSources));
  }
};



int main() {
  
  cv::Mat image = cv::imread("../test2.jpg");
  auto start = std::chrono::high_resolution_clock::now();

  extractLightSources(image, 0.4, 4, 6);

  auto end = std::chrono::high_resolution_clock::now();

  std::chrono::duration<double> elapsed = end - start;
  std::cout << "Time taken: " << elapsed.count() << " seconds" << std::endl;

  return 0;
}