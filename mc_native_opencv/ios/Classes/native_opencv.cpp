#include "MorseCodeLightTracker.h"
#include <opencv2/core.hpp>

static MorseCodeLightTracker* lighttracker = nullptr;

struct MorseSignalResult {
    int count;
    MorseSignal signals[]; // flexible array member
};

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
    bool testing(bool test) {
        if (lighttracker!=NULL) {
            return lighttracker->testFunction(test);
        }
        return false;
    };

    __attribute__((visibility("default"))) __attribute__((used))
    MorseSignalResult* updateLights(uint8_t* bytes, int width, int height, long long timestamp) {
        std::vector<MorseSignal> signals = lighttracker->updateLights(bytes, width, height, timestamp);
        size_t size = sizeof(MorseSignalResult) + sizeof(MorseSignal) * signals.size();
        MorseSignalResult* output = (MorseSignalResult*) malloc(size);

        output->count = signals.size();
        for (size_t i = 0; i < signals.size(); ++i) {
            output->signals[i] = signals[i];
        }

        return output;
    }
}