#pragma once

#include <deque>
#include <opencv2/core/mat.hpp>
#include <vector>
#include <opencv2/opencv.hpp>

constexpr int MAX_LIGHT_SOURCES = 100;
constexpr int MAX_AGE = 5;

struct LightSource {
    bool isOn;
    cv::Rect boundingBox;
    int toggleCount = 0;
    int age = 0;
    int id;
    std::deque<bool> toggleHistory;

    LightSource(bool isOn, const cv::Rect &boundingBox, int toggleCount = 0);
};

struct MorseSignal {
    bool isOn;
    long timestamp;
};

class MorseCodeLightTracker {
private:
    std::deque<std::vector<LightSource>> history;
    std::deque<long> timestamps;
    size_t maxSize;
    bool trackingLight = false;
    int trackedLightID = -1;


    std::vector<LightSource> detectLightSources(cv::Mat &image);
    std::vector<LightSource> extractLightSources(cv::Mat &image, double scaleFactor,int cropColWidth, int cropRowHeight);
    void addFrame(std::vector<LightSource> &&newSources);

public:
    explicit MorseCodeLightTracker(size_t maxSize);
    std::vector<MorseSignal> processFrame(const std::vector<LightSource> &detectedLights, long long timestamp);
    std::vector<MorseSignal> updateLights(uint8_t* bytes, int width, int height, long long timestamp);

    std::deque<bool> sendLightBuffer(LightSource &light);
    bool sendLight(LightSource &light);
    bool testFunction(bool var);
};

