#pragma once

#include <deque>
#include <opencv2/core/mat.hpp>
#include <vector>
#include <opencv2/opencv.hpp>

constexpr int MAX_LIGHT_SOURCES = 100;
constexpr int MAX_AGE = 150;

struct LightSource {
    bool isOn = false;
    cv::Rect boundingBox; 
    // cv::Rect boundingBox = {0, 0, 0, 0}; 
    int toggleCount = 0;
    int age = 0;
    int id;
    bool hasExceededThreshold = false;
    std::deque<bool> toggleHistory;

    LightSource() = default;
    LightSource(bool isOn, const cv::Rect &boundingBox, int toggleCount = 0);
};

struct MorseSignal {
    bool isOn;
    long long timestamp;
};

class MorseCodeLightTracker {
private:
    std::deque<std::vector<LightSource>> history;
    std::deque<long> timestamps;
    size_t maxSize;
    bool trackingLight = false;
    int trackedLightID = -1;
    static int nextID;


    std::vector<LightSource> detectLightSources(cv::Mat &image);
    std::vector<LightSource> extractLightSources(cv::Mat &image, double scaleFactor,int cropColWidth, int cropRowHeight);
    void addFrame(std::vector<LightSource> &&newSources);
    void updateLightSource(LightSource &newSrc, LightSource &oldSrc, long long timestamp, std::vector<MorseSignal> &signalsToSend);

public:
    explicit MorseCodeLightTracker(size_t maxSize);
    std::vector<MorseSignal> processFrame(std::vector<LightSource> &detectedLights, long long timestamp);
    std::vector<MorseSignal> updateLights(cv::Mat& image, int width, int height, long long timestamp);

    std::deque<bool> sendLightBuffer(LightSource &light);
    bool sendLight(LightSource &light);
    bool testFunction(bool var);

    static int getNextID();
};

