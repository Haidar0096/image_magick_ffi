#pragma once
#include <stdlib.h>
#include <stdbool.h>

/* Include the local headers if __FFIGEN__ is defined. */
#ifdef __FFIGEN__
#include "ffigen_deps/MagickCore/magick-baseconfig.h"
#else
#include <MagickCore/magick-baseconfig.h>
#endif

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

FFI_PLUGIN_EXPORT bool magickSetResourceLimit(const int type, const unsigned long long limit);

FFI_PLUGIN_EXPORT bool magickSetResolution(void* wand, const double x_resolution, const double y_resolution);

FFI_PLUGIN_EXPORT bool magickSetSamplingFactors(void* wand, const size_t number_factors, const double* sampling_factors);

FFI_PLUGIN_EXPORT void magickSetSeed(const unsigned long seed);

FFI_PLUGIN_EXPORT bool magickSetSecurityPolicy(void* wand, const char* policy);

FFI_PLUGIN_EXPORT bool magickSetSize(void* wand, const size_t columns, const size_t rows);

FFI_PLUGIN_EXPORT bool magickSetSizeOffset(void* wand, const size_t columns, const size_t rows, const ssize_t offset);

FFI_PLUGIN_EXPORT bool magickSetType(void* wand, const int image_type);

FFI_PLUGIN_EXPORT void* getImageFromMagickWand(const void* wand);

FFI_PLUGIN_EXPORT bool magickAdaptiveBlurImage(void* wand, const double radius, const double sigma);

FFI_PLUGIN_EXPORT bool magickAdaptiveResizeImage(void* wand, const size_t columns, const size_t rows);

FFI_PLUGIN_EXPORT bool magickAdaptiveSharpenImage(void* wand, const double radius, const double sigma);

FFI_PLUGIN_EXPORT bool magickAdaptiveThresholdImage(void* wand, const size_t width, const size_t height, const double bias);

FFI_PLUGIN_EXPORT bool magickAddImage(void* wand, const void* add_wand);

FFI_PLUGIN_EXPORT bool magickAddNoiseImage(void* wand, const int noise_type, const double attenuate);

FFI_PLUGIN_EXPORT bool magickAffineTransformImage(void* wand, const void* drawing_wand);

FFI_PLUGIN_EXPORT bool magickAnnotateImage(void* wand, const void* drawing_wand, const double x, const double y, const double angle, const char* text);

FFI_PLUGIN_EXPORT bool magickAnimateImages(void* wand, const char* server_name);

FFI_PLUGIN_EXPORT void* magickAppendImages(void* wand, const bool stack);

FFI_PLUGIN_EXPORT bool magickAutoGammaImage(void* wand);

FFI_PLUGIN_EXPORT bool magickAutoLevelImage(void* wand);

FFI_PLUGIN_EXPORT bool magickAutoOrientImage(void* wand);

FFI_PLUGIN_EXPORT bool magickAutoThresholdImage(void* wand, const int method);

FFI_PLUGIN_EXPORT bool magickBilateralBlurImage(void* wand, const double radius, const double sigma, const double intensity_sigma, const double spatial_sigma);

FFI_PLUGIN_EXPORT bool magickBlackThresholdImage(void* wand, const void* threshold_wand);

FFI_PLUGIN_EXPORT bool magickBlueShiftImage(void* wand, const double factor);

FFI_PLUGIN_EXPORT bool magickBlurImage(void* wand, const double radius, const double sigma);

FFI_PLUGIN_EXPORT bool magickBorderImage(void* wand, const void* bordercolor_wand, const size_t width, const size_t height, const int compose);

FFI_PLUGIN_EXPORT bool magickBrightnessContrastImage(void* wand, const double brightness, const double contrast);

FFI_PLUGIN_EXPORT bool magickCannyEdgeImage(void* wand, const double radius, const double sigma, const double lower_percent, const double upper_percent);

FFI_PLUGIN_EXPORT void* magickChannelFxImage(void* wand, const char* expression);

FFI_PLUGIN_EXPORT bool magickCharcoalImage(void* wand, const double radius, const double sigma);

FFI_PLUGIN_EXPORT bool magickChopImage(void* wand, const size_t width, const size_t height, const ssize_t x, const ssize_t y);

FFI_PLUGIN_EXPORT bool magickCLAHEImage(void* wand, const size_t width, const size_t height, const double number_bins, const double clip_limit);

FFI_PLUGIN_EXPORT bool magickClampImage(void* wand);

FFI_PLUGIN_EXPORT bool magickClipImage(void* wand);

FFI_PLUGIN_EXPORT bool magickClipImagePath(void* wand, const char* pathname, const bool inside);

FFI_PLUGIN_EXPORT bool magickClutImage(void* wand, const void* clut_wand, const int method);

FFI_PLUGIN_EXPORT void* magickCoalesceImages(void* wand);

FFI_PLUGIN_EXPORT bool magickColorDecisionListImage(void* wand, const char* color_correction_collection);

FFI_PLUGIN_EXPORT bool magickColorizeImage(void* wand, const void* colorize, const void* blend);

FFI_PLUGIN_EXPORT bool magickColorMatrixImage(void* wand, const void* color_matrix);

FFI_PLUGIN_EXPORT bool magickColorThresholdImage(void* wand, const void* start_color, const void* stop_color);

FFI_PLUGIN_EXPORT void* magickCombineImages(void* wand, const int colorspace);

FFI_PLUGIN_EXPORT bool magickCommentImage(void* wand, const char* comment);

FFI_PLUGIN_EXPORT void* magickCompareImagesLayers(void* wand, const int method);

FFI_PLUGIN_EXPORT void* magickCompareImages(void* wand, const void* reference, const int metric, double* distortion);

FFI_PLUGIN_EXPORT void* magickComplexImages(void* wand, const int op);

FFI_PLUGIN_EXPORT bool magickCompositeImage(void* wand, const void* source_wand, const int compose, const bool clip_to_self, const ssize_t x, const ssize_t y);

FFI_PLUGIN_EXPORT bool magickCompositeImageGravity(void* wand, const void* source_wand, const int compose, const int gravity);

FFI_PLUGIN_EXPORT bool magickCompositeLayers(void* wand, const void* source_wand, const int compose, const ssize_t x, const ssize_t y);

FFI_PLUGIN_EXPORT bool magickContrastImage(void* wand, const bool sharpen);

FFI_PLUGIN_EXPORT bool magickContrastStretchImage(void* wand, const double black_point, const double white_point);

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT bool magickReadImage(void* wand, const char* filename);

FFI_PLUGIN_EXPORT bool magickWriteImage(void* wand, const char* filename);