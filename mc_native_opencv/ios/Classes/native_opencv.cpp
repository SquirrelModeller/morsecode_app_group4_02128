#include "MorseCodeLightTracker.h"
#include <opencv2/core.hpp>
#include "android/log.h"
#include <opencv2/opencv.hpp>

// Used information from https://github.com/ValYouW/flutter-opencv-stream-processing, author ValYouW, for exposing function to Flutter/Dart.
// Written/Modified by William Pii Jæger

static MorseCodeLightTracker* lighttracker = nullptr;

extern "C" {
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void initLightTracker(int maxSize) {
        if (lighttracker != nullptr) {
            delete lighttracker;
            lighttracker = nullptr;
        }

        lighttracker = new MorseCodeLightTracker(maxSize);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void destroyLightTracker() {
        if (lighttracker != nullptr) {
            delete lighttracker;
            lighttracker = nullptr;
        }
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const long long* detect(int width, int height, uint8_t* bytes, long long timestamp, int32_t* outCount)  {

        if (lighttracker == nullptr) {
            long long* jres = new long long[1];
            jres[0] = 0;
            return jres;
        }

        cv::Mat frame;
        cv::Mat myyuv(height + height/2, width, CV_8UC1, bytes);
        cv::cvtColor(myyuv, frame, cv::COLOR_YUV2BGRA_NV21);

        std::vector<MorseSignal> res = lighttracker->updateLights(frame, width, height, timestamp);

        std::vector<long long> output;

        for (int i = 0; i < res.size(); i++) {
            output.push_back(res[i].isOn ? 1 : 0);
            output.push_back(res[i].timestamp);
        }

        unsigned int total = sizeof(long long) * output.size();
        long long* jres = (long long*) malloc(total);
        memcpy(jres, output.data(), total);



        *outCount = output.size();
        return jres;
    }
}