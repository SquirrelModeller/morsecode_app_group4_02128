#ifndef ANALYZEFLASHLIGHT_H
#define ANALYZEFLASHLIGHT_H

#include <opencv2/opencv.hpp>
#include <string>

struct MorseSignal {
    bool isOn;
    long unixTime;
};

// MorseSignal analyzeFlashLight(const cv::Mat& image);
class AnalyzeFlashLight {

};

void initFrameLightManager();

void receiveImage();


#endif