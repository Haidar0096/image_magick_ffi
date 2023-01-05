#include <stdlib.h>
#include <stdbool.h>

#include <MagickCore/magick-baseconfig.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

/*############################################ Dart Sdk Api ############################################*/
FFI_PLUGIN_EXPORT intptr_t initDartAPI(void* data);
/*############################################ Dart Sdk Api ############################################*/

FFI_PLUGIN_EXPORT void clearMagickWand(void* wand);

FFI_PLUGIN_EXPORT void* cloneMagickWand(const void* wand);

FFI_PLUGIN_EXPORT void* destroyMagickWand(void* wand);

FFI_PLUGIN_EXPORT bool isMagickWand(const void* wand);

FFI_PLUGIN_EXPORT bool magickClearException(void* wand);

FFI_PLUGIN_EXPORT char* magickGetException(const void* wand, int* severity);

FFI_PLUGIN_EXPORT int magickGetExceptionType(const void* wand);

FFI_PLUGIN_EXPORT ssize_t magickGetIteratorIndex(void* wand);

FFI_PLUGIN_EXPORT char* magickQueryConfigureOption(const char* option);

FFI_PLUGIN_EXPORT char** magickQueryConfigureOptions(const char* pattern, size_t* number_options);

FFI_PLUGIN_EXPORT double* magickQueryFontMetrics(void* wand, const void* drawing_wand, const char* text);

FFI_PLUGIN_EXPORT double* magickQueryMultilineFontMetrics(void* wand, const void* drawing_wand, const char* text);

FFI_PLUGIN_EXPORT char** magickQueryFonts(const char* pattern, size_t* number_fonts);

FFI_PLUGIN_EXPORT char** magickQueryFormats(const char* pattern, size_t* number_formats);

FFI_PLUGIN_EXPORT void* magickRelinquishMemory(void* resource);

FFI_PLUGIN_EXPORT void magickResetIterator(void* wand);

FFI_PLUGIN_EXPORT void magickSetFirstIterator(void* wand);

FFI_PLUGIN_EXPORT bool magickSetIteratorIndex(void* wand, const ssize_t index);

FFI_PLUGIN_EXPORT void magickSetLastIterator(void* wand);

FFI_PLUGIN_EXPORT void magickWandGenesis(void);

FFI_PLUGIN_EXPORT void magickWandTerminus(void);

FFI_PLUGIN_EXPORT void* newMagickWand(void);

FFI_PLUGIN_EXPORT void* newMagickWandFromImage(const void* image);

FFI_PLUGIN_EXPORT bool isMagickWandInstantiated(void);

FFI_PLUGIN_EXPORT bool magickDeleteImageArtifact(void* wand, const char* artifact);

FFI_PLUGIN_EXPORT bool magickDeleteImageProperty(void* wand, const char* property);

FFI_PLUGIN_EXPORT bool magickDeleteOption(void* wand, const char* option);

FFI_PLUGIN_EXPORT bool magickGetAntialias(const void* wand);

FFI_PLUGIN_EXPORT void* magickGetBackgroundColor(void* wand);

FFI_PLUGIN_EXPORT int magickGetColorspace(void* wand);

FFI_PLUGIN_EXPORT int magickGetCompression(void* wand);

FFI_PLUGIN_EXPORT size_t magickGetCompressionQuality(void* wand);

FFI_PLUGIN_EXPORT const char* magickGetCopyright(void);

FFI_PLUGIN_EXPORT const char* magickGetFilename(const void* wand);

FFI_PLUGIN_EXPORT char* magickGetFont(void* wand);

FFI_PLUGIN_EXPORT const char* magickGetFormat(void* wand);

FFI_PLUGIN_EXPORT int magickGetGravity(void* wand);

FFI_PLUGIN_EXPORT char* magickGetHomeURL(void);

FFI_PLUGIN_EXPORT char* magickGetImageArtifact(void* wand, const char* artifact);

FFI_PLUGIN_EXPORT char** magickGetImageArtifacts(void* wand, const char* pattern, size_t* number_artifacts);

FFI_PLUGIN_EXPORT unsigned char* magickGetImageProfile(void* wand, const char* name, size_t* length);

FFI_PLUGIN_EXPORT char** magickGetImageProfiles(void* wand, const char* pattern, size_t* number_profiles);

FFI_PLUGIN_EXPORT char* magickGetImageProperty(void* wand, const char* property);

FFI_PLUGIN_EXPORT char** magickGetImageProperties(void* wand, const char* pattern, size_t* number_properties);

FFI_PLUGIN_EXPORT int magickGetInterlaceScheme(void* wand);

FFI_PLUGIN_EXPORT int magickGetInterpolateMethod(void* wand);

FFI_PLUGIN_EXPORT char* magickGetOption(void* wand, const char* key);

FFI_PLUGIN_EXPORT char** magickGetOptions(void* wand, const char* pattern, size_t* number_options);

FFI_PLUGIN_EXPORT int magickGetOrientation(void* wand);

FFI_PLUGIN_EXPORT const char* magickGetPackageName(void);

FFI_PLUGIN_EXPORT bool magickGetPage(const void* wand, size_t* width, size_t* height, ssize_t* x, ssize_t* y);

FFI_PLUGIN_EXPORT double magickGetPointsize(void* wand);

FFI_PLUGIN_EXPORT const char* magickGetQuantumDepth(size_t* depth);

FFI_PLUGIN_EXPORT const char* magickGetQuantumRange(size_t* range);

FFI_PLUGIN_EXPORT const char* magickGetReleaseDate(void);

FFI_PLUGIN_EXPORT bool magickGetResolution(const void* wand, double* x, double* y);

FFI_PLUGIN_EXPORT unsigned long long magickGetResource(const int type);

FFI_PLUGIN_EXPORT unsigned long long magickGetResourceLimit(const int type);

FFI_PLUGIN_EXPORT double* magickGetSamplingFactors(void* wand, size_t* number_factors);

FFI_PLUGIN_EXPORT bool magickGetSize(const void* wand, size_t* columns, size_t* rows);

FFI_PLUGIN_EXPORT bool magickGetSizeOffset(const void* wand, ssize_t* offset);

FFI_PLUGIN_EXPORT int magickGetType(void* wand);

FFI_PLUGIN_EXPORT const char* magickGetVersion(size_t* version);

FFI_PLUGIN_EXPORT bool magickProfileImage(void* wand, const char* name, const void* profile, const size_t length);

FFI_PLUGIN_EXPORT unsigned char* magickRemoveImageProfile(void* wand, const char* name, size_t* length);

FFI_PLUGIN_EXPORT bool magickSetAntialias(void* wand, const bool antialias);

FFI_PLUGIN_EXPORT bool magickSetBackgroundColor(void* wand, const void* background);

FFI_PLUGIN_EXPORT bool magickSetColorspace(void* wand, const int colorspace);

FFI_PLUGIN_EXPORT bool magickSetCompression(void* wand, const int compression);

FFI_PLUGIN_EXPORT bool magickSetCompressionQuality(void* wand, const size_t quality);

FFI_PLUGIN_EXPORT bool magickSetDepth(void* wand, const size_t depth);

FFI_PLUGIN_EXPORT bool magickSetExtract(void* wand, const char* geometry);

FFI_PLUGIN_EXPORT bool magickSetFilename(void* wand, const char* filename);

FFI_PLUGIN_EXPORT bool magickSetFont(void* wand, const char* font);

FFI_PLUGIN_EXPORT bool magickSetFormat(void* wand, const char* format);

FFI_PLUGIN_EXPORT bool magickSetGravity(void* wand, const int type);

FFI_PLUGIN_EXPORT bool magickSetImageArtifact(void* wand, const char* artifact, const char* value);

FFI_PLUGIN_EXPORT bool magickSetImageProfile(void* wand, const char* name, const void* profile, const size_t length);

FFI_PLUGIN_EXPORT bool magickSetImageProperty(void* wand, const char* property, const char* value);

FFI_PLUGIN_EXPORT bool magickSetInterlaceScheme(void* wand, const int interlace_scheme);

FFI_PLUGIN_EXPORT bool magickSetInterpolateMethod(void* wand, const int method);

FFI_PLUGIN_EXPORT bool magickSetOption(void* wand, const char* key, const char* value);

FFI_PLUGIN_EXPORT bool magickSetOrientation(void* wand, const int orientation);

FFI_PLUGIN_EXPORT bool magickSetPage(void* wand, const size_t width, const size_t height, const ssize_t x, const ssize_t y);

FFI_PLUGIN_EXPORT bool magickSetPassphrase(void* wand, const char* passphrase);

FFI_PLUGIN_EXPORT bool magickSetPointsize(void* wand, const double pointsize);

FFI_PLUGIN_EXPORT intptr_t* magickSetProgressMonitorPort(void* wand, intptr_t sendPort);

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT bool magickReadImage(void* wand, const char* filename);

FFI_PLUGIN_EXPORT bool magickWriteImage(void* wand, const char* filename);