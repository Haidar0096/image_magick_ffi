#include <stdlib.h>
#include <string.h>
#include<stdbool.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT void resize(const char* inputFilePath, const char* outputFilePath, int width, int height, char* errorOut, int maxErrorOutSize);