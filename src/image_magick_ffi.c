#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>
#include "dart_api_dl.h"
#include <json.h>

/*########################################## Dart Sdk Api ############################################*/
FFI_PLUGIN_EXPORT intptr_t initDartAPI(void* data) {
	return Dart_InitializeApiDL(data);
}
/*########################################## Dart Sdk Api ############################################*/

FFI_PLUGIN_EXPORT void clearMagickWand(void* wand) {
	ClearMagickWand((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT void* cloneMagickWand(const void* wand) {
	return CloneMagickWand((const MagickWand*)wand);
}

FFI_PLUGIN_EXPORT void* destroyMagickWand(void* wand) {
	return DestroyMagickWand((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT bool isMagickWand(const void* wand) {
	return IsMagickWand((const MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClearException(void* wand) {
	return MagickClearException((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT char* magickGetException(const void* wand, int* severity) {
	return MagickGetException((const MagickWand*)wand, (ExceptionType*)severity);
}

FFI_PLUGIN_EXPORT int magickGetExceptionType(const void* wand) {
	return MagickGetExceptionType((const MagickWand*)wand);
}

FFI_PLUGIN_EXPORT ssize_t magickGetIteratorIndex(void* wand) {
	return MagickGetIteratorIndex((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT char* magickQueryConfigureOption(const char* option) {
	return MagickQueryConfigureOption(option);
}

FFI_PLUGIN_EXPORT char** magickQueryConfigureOptions(const char* pattern, size_t* number_options) {
	return MagickQueryConfigureOptions(pattern, number_options);
}

FFI_PLUGIN_EXPORT double* magickQueryFontMetrics(void* wand, const void* drawing_wand, const char* text) {
	return MagickQueryFontMetrics((MagickWand*)wand, (DrawingWand*)drawing_wand, text);
}

FFI_PLUGIN_EXPORT double* magickQueryMultilineFontMetrics(void* wand, const void* drawing_wand, const char* text) {
	return MagickQueryMultilineFontMetrics((MagickWand*)wand, (DrawingWand*)drawing_wand, text);
}

FFI_PLUGIN_EXPORT char** magickQueryFonts(const char* pattern, size_t* number_fonts) {
	return MagickQueryFonts(pattern, number_fonts);
}

FFI_PLUGIN_EXPORT char** magickQueryFormats(const char* pattern, size_t* number_formats) {
	return MagickQueryFormats(pattern, number_formats);
}

FFI_PLUGIN_EXPORT void* magickRelinquishMemory(void* resource) {
	return MagickRelinquishMemory(resource);
}

FFI_PLUGIN_EXPORT void magickResetIterator(void* wand) {
	MagickResetIterator((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT void magickSetFirstIterator(void* wand) {
	MagickSetFirstIterator((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT bool magickSetIteratorIndex(void* wand, const ssize_t index) {
	return MagickSetIteratorIndex((MagickWand*)wand, index) == MagickTrue;
}

FFI_PLUGIN_EXPORT void magickSetLastIterator(void* wand) {
	MagickSetLastIterator((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT void magickWandGenesis(void) {
	MagickWandGenesis();
}

FFI_PLUGIN_EXPORT void magickWandTerminus(void) {
	MagickWandTerminus();
}

FFI_PLUGIN_EXPORT void* newMagickWand(void) {
	return NewMagickWand();
}

FFI_PLUGIN_EXPORT void* newMagickWandFromImage(const void* image) {
	return NewMagickWandFromImage((const Image*)image);
}

FFI_PLUGIN_EXPORT bool isMagickWandInstantiated(void) {
	return IsMagickWandInstantiated() == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteImageArtifact(void* wand, const char* artifact) {
	return MagickDeleteImageArtifact((MagickWand*)wand, artifact) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteImageProperty(void* wand, const char* property) {
	return MagickDeleteImageProperty((MagickWand*)wand, property) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteOption(void* wand, const char* option) {
	return MagickDeleteOption((MagickWand*)wand, option) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickGetAntialias(const void* wand) {
	return MagickGetAntialias((const MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickGetBackgroundColor(void* wand) {
	return MagickGetBackgroundColor((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT int magickGetColorspace(void* wand) {
	return MagickGetColorspace((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT int magickGetCompression(void* wand) {
	return MagickGetCompression((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT size_t magickGetCompressionQuality(void* wand) {
	return MagickGetCompressionQuality((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT const char* magickGetCopyright(void) {
	return MagickGetCopyright();
}

FFI_PLUGIN_EXPORT const char* magickGetFilename(const void* wand) {
	return MagickGetFilename((const MagickWand*)wand);
}

FFI_PLUGIN_EXPORT char* magickGetFont(void* wand) {
	return MagickGetFont((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT const char* magickGetFormat(void* wand) {
	return MagickGetFormat((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT int magickGetGravity(void* wand) {
	return MagickGetGravity((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT char* magickGetHomeURL(void) {
	return MagickGetHomeURL();
}

FFI_PLUGIN_EXPORT char* magickGetImageArtifact(void* wand, const char* artifact) {
	return MagickGetImageArtifact((MagickWand*)wand, artifact);
}

FFI_PLUGIN_EXPORT char** magickGetImageArtifacts(void* wand, const char* pattern, size_t* number_artifacts) {
	return MagickGetImageArtifacts((MagickWand*)wand, pattern, number_artifacts);
}

FFI_PLUGIN_EXPORT unsigned char* magickGetImageProfile(void* wand, const char* name, size_t* length) {
	return MagickGetImageProfile((MagickWand*)wand, name, length);
}

FFI_PLUGIN_EXPORT char** magickGetImageProfiles(void* wand, const char* pattern, size_t* number_profiles) {
	return MagickGetImageProfiles((MagickWand*)wand, pattern, number_profiles);
}

FFI_PLUGIN_EXPORT char* magickGetImageProperty(void* wand, const char* property) {
	return MagickGetImageProperty((MagickWand*)wand, property);
}

FFI_PLUGIN_EXPORT char** magickGetImageProperties(void* wand, const char* pattern, size_t* number_properties) {
	return MagickGetImageProperties((MagickWand*)wand, pattern, number_properties);
}

FFI_PLUGIN_EXPORT int magickGetInterlaceScheme(void* wand) {
	return MagickGetInterlaceScheme((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT int magickGetInterpolateMethod(void* wand) {
	return MagickGetInterpolateMethod((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT char* magickGetOption(void* wand, const char* key) {
	return MagickGetOption((MagickWand*)wand, key);
}

FFI_PLUGIN_EXPORT char** magickGetOptions(void* wand, const char* pattern, size_t* number_options) {
	return MagickGetOptions((MagickWand*)wand, pattern, number_options);
}

FFI_PLUGIN_EXPORT int magickGetOrientation(void* wand) {
	return MagickGetOrientation((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT const char* magickGetPackageName(void) {
	return MagickGetPackageName();
}

FFI_PLUGIN_EXPORT bool magickGetPage(const void* wand, size_t* width, size_t* height, ssize_t* x, ssize_t* y) {
	return MagickGetPage((const MagickWand*)wand, width, height, x, y) == MagickTrue;
}

FFI_PLUGIN_EXPORT double magickGetPointsize(void* wand) {
	return MagickGetPointsize((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT const char* magickGetQuantumDepth(size_t* depth) {
	return MagickGetQuantumDepth(depth);
}

FFI_PLUGIN_EXPORT const char* magickGetQuantumRange(size_t* range) {
	return MagickGetQuantumRange(range);
}

FFI_PLUGIN_EXPORT const char* magickGetReleaseDate(void) {
	return MagickGetReleaseDate();
}

FFI_PLUGIN_EXPORT bool magickGetResolution(const void* wand, double* x, double* y) {
	return MagickGetResolution((const MagickWand*)wand, x, y) == MagickTrue;
}

FFI_PLUGIN_EXPORT unsigned long long magickGetResource(const int type) {
	return MagickGetResource(type);
}

FFI_PLUGIN_EXPORT unsigned long long magickGetResourceLimit(const int type) {
	return MagickGetResourceLimit(type);
}

FFI_PLUGIN_EXPORT double* magickGetSamplingFactors(void* wand, size_t* number_factors) {
	return MagickGetSamplingFactors((MagickWand*)wand, number_factors);
}

FFI_PLUGIN_EXPORT bool magickGetSize(const void* wand, size_t* columns, size_t* rows) {
	return MagickGetSize((const MagickWand*)wand, columns, rows) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickGetSizeOffset(const void* wand, ssize_t* offset) {
	return MagickGetSizeOffset((const MagickWand*)wand, offset) == MagickTrue;
}

FFI_PLUGIN_EXPORT int magickGetType(void* wand) {
	return MagickGetType((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT const char* magickGetVersion(size_t* version) {
	return MagickGetVersion(version);
}

FFI_PLUGIN_EXPORT bool magickProfileImage(void* wand, const char* name, const void* profile, const size_t length) {
	return MagickProfileImage((MagickWand*)wand, name, profile, length) == MagickTrue;
}

FFI_PLUGIN_EXPORT unsigned char* magickRemoveImageProfile(void* wand, const char* name, size_t* length) {
	return MagickRemoveImageProfile((MagickWand*)wand, name, length);
}

FFI_PLUGIN_EXPORT bool magickSetAntialias(void* wand, const bool antialias) {
	return MagickSetAntialias((MagickWand*)wand, antialias) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetBackgroundColor(void* wand, const void* background) {
	// TODO: test this when PixelWand is implemented in dart
	return MagickSetBackgroundColor((MagickWand*)wand, (const PixelWand*)background) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetColorspace(void* wand, const int colorspace) {
	return MagickSetColorspace((MagickWand*)wand, colorspace) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetCompression(void* wand, const int compression) {
	return MagickSetCompression((MagickWand*)wand, compression) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetCompressionQuality(void* wand, const size_t quality) {
	return MagickSetCompressionQuality((MagickWand*)wand, quality) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetDepth(void* wand, const size_t depth) {
	return MagickSetDepth((MagickWand*)wand, depth) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetExtract(void* wand, const char* geometry) {
	return MagickSetExtract((MagickWand*)wand, geometry) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFilename(void* wand, const char* filename) {
	return MagickSetFilename((MagickWand*)wand, filename) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFont(void* wand, const char* font) {
	return MagickSetFont((MagickWand*)wand, font) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFormat(void* wand, const char* format) {
	return MagickSetFormat((MagickWand*)wand, format) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetGravity(void* wand, const int type) {
	return MagickSetGravity((MagickWand*)wand, type) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageArtifact(void* wand, const char* artifact, const char* value) {
	return MagickSetImageArtifact((MagickWand*)wand, artifact, value) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageProfile(void* wand, const char* name, const void* profile, const size_t length) {
	return MagickSetImageProfile((MagickWand*)wand, name, profile, length) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageProperty(void* wand, const char* property, const char* value) {
	return MagickSetImageProperty((MagickWand*)wand, property, value) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetInterlaceScheme(void* wand, const int interlace_scheme) {
	return MagickSetInterlaceScheme((MagickWand*)wand, interlace_scheme) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetInterpolateMethod(void* wand, const int method) {
	return MagickSetInterpolateMethod((MagickWand*)wand, method) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetOption(void* wand, const char* key, const char* value) {
	return MagickSetOption((MagickWand*)wand, key, value) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetOrientation(void* wand, const int orientation) {
	return MagickSetOrientation((MagickWand*)wand, orientation) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPage(void* wand, const size_t width, const size_t height, const ssize_t x, const ssize_t y) {
	return MagickSetPage((MagickWand*)wand, width, height, x, y) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPassphrase(void* wand, const char* passphrase) {
	return MagickSetPassphrase((MagickWand*)wand, passphrase) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPointsize(void* wand, const double pointsize) {
	return MagickSetPointsize((MagickWand*)wand, pointsize) == MagickTrue;
}

json_object* progressInfoToJsonObject(const char* text, const MagickOffsetType offset, const MagickSizeType size) {
	const char* infoKey = "info";
	const char* sizeKey = "size";
	const char* offsetKey = "offset";

	json_object* jobj = json_object_new_object();
	json_object_object_add(jobj, infoKey, json_object_new_string(text));
	json_object_object_add(jobj, sizeKey, json_object_new_uint64(size));
	json_object_object_add(jobj, offsetKey, json_object_new_int64(offset));
	return jobj;
}

MagickBooleanType progressMonitor(const char* text, const MagickOffsetType offset, const MagickSizeType size, void* clientData) {
	json_object* jobj = progressInfoToJsonObject(text, offset, size);
	intptr_t sendPort = *((intptr_t*)clientData);
	Dart_CObject* message = malloc(sizeof * message);
	message->type = Dart_CObject_kString;
	message->value.as_string = json_object_to_json_string_ext(jobj, JSON_C_TO_STRING_PRETTY); // TODO: update the dart sdk to remove the warning here
	Dart_PostCObject_DL(sendPort, message);
	json_object_put(jobj);
	free(message);
	return MagickTrue; // TODO: find a way to get the dart's method return value and return it here to support canceling
}


FFI_PLUGIN_EXPORT intptr_t* magickSetProgressMonitorPort(void* wand, intptr_t sendPort) {
	intptr_t* sendPortPtr = malloc(sizeof * sendPortPtr);
	*sendPortPtr = sendPort;
	MagickSetProgressMonitor((MagickWand*)wand, progressMonitor, sendPortPtr);
	return sendPortPtr;
}

FFI_PLUGIN_EXPORT bool magickSetResourceLimit(const int type, const unsigned long long limit) {
	return MagickSetResourceLimit(type, limit) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetResolution(void* wand, const double x_resolution, const double y_resolution) {
	return MagickSetResolution((MagickWand*)wand, x_resolution, y_resolution) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetSamplingFactors(void* wand, const size_t number_factors, const double* sampling_factors) {
	return MagickSetSamplingFactors((MagickWand*)wand, number_factors, sampling_factors) == MagickTrue;
}

FFI_PLUGIN_EXPORT void magickSetSeed(const unsigned long seed) {
	MagickSetSeed(seed);
}

FFI_PLUGIN_EXPORT bool magickSetSecurityPolicy(void* wand, const char* policy) {
	return MagickSetSecurityPolicy((MagickWand*)wand, policy) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetSize(void* wand, const size_t columns, const size_t rows) {
	return MagickSetSize(wand, columns, rows) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetSizeOffset(void* wand, const size_t columns, const size_t rows, const ssize_t offset) {
	return MagickSetSizeOffset(wand, columns, rows, offset) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetType(void* wand, const int image_type) {
	return MagickSetType((MagickWand*)wand, image_type) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* getImageFromMagickWand(const void* wand) {
	return GetImageFromMagickWand((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT bool magickAdaptiveBlurImage(void* wand, const double radius, const double sigma) {
	return MagickAdaptiveBlurImage((MagickWand*)wand, radius, sigma) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAdaptiveResizeImage(void* wand, const size_t columns, const size_t rows) {
	return MagickAdaptiveResizeImage((MagickWand*)wand, columns, rows) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAdaptiveSharpenImage(void* wand, const double radius, const double sigma) {
	return MagickAdaptiveSharpenImage((MagickWand*)wand, radius, sigma) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAdaptiveThresholdImage(void* wand, const size_t width, const size_t height, const double bias) {
	return MagickAdaptiveThresholdImage((MagickWand*)wand, width, height, bias) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAddImage(void* wand, const void* add_wand) {
	return MagickAddImage((MagickWand*)wand, (const MagickWand*)add_wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAddNoiseImage(void* wand, const int noise_type, const double attenuate) {
	return MagickAddNoiseImage((MagickWand*)wand, noise_type, attenuate) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAffineTransformImage(void* wand, const void* drawing_wand) {
	return MagickAffineTransformImage((MagickWand*)wand, (DrawingWand*)drawing_wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAnnotateImage(void* wand, const void* drawing_wand, const double x, const double y, const double angle, const char* text) {
	return MagickAnnotateImage((MagickWand*)wand, (DrawingWand*)drawing_wand, x, y, angle, text) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAnimateImages(void* wand, const char* server_name) {
	return MagickAnimateImages((MagickWand*)wand, server_name) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickAppendImages(void* wand, const bool stack) {
	return MagickAppendImages((MagickWand*)wand, stack);
}

FFI_PLUGIN_EXPORT bool magickAutoGammaImage(void* wand) {
	return MagickAutoGammaImage((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAutoLevelImage(void* wand) {
	return MagickAutoLevelImage((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAutoOrientImage(void* wand) {
	return MagickAutoOrientImage((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickAutoThresholdImage(void* wand, const AutoThresholdMethod method) {
	return MagickAutoThresholdImage((MagickWand*)wand, method) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBilateralBlurImage(void* wand, const double radius, const double sigma, const double intensity_sigma, const double spatial_sigma) {
	return MagickBilateralBlurImage((MagickWand*)wand, radius, sigma, intensity_sigma, spatial_sigma) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBlackThresholdImage(void* wand, const void* threshold_wand) {
	return MagickBlackThresholdImage((MagickWand*)wand, (PixelWand*)threshold_wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBlueShiftImage(void* wand, const double factor) {
	return MagickBlueShiftImage((MagickWand*)wand, factor) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBlurImage(void* wand, const double radius, const double sigma) {
	return MagickBlurImage((MagickWand*)wand, radius, sigma) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBorderImage(void* wand, const void* bordercolor_wand, const size_t width, const size_t height, const int compose) {
	return MagickBorderImage((MagickWand*)wand, (PixelWand*)bordercolor_wand, width, height, compose) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickBrightnessContrastImage(void* wand, const double brightness, const double contrast) {
	return MagickBrightnessContrastImage((MagickWand*)wand, brightness, contrast) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickCannyEdgeImage(void* wand, const double radius, const double sigma, const double lower_percent, const double upper_percent) {
	return MagickCannyEdgeImage((MagickWand*)wand, radius, sigma, lower_percent, upper_percent) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickChannelFxImage(void* wand, const char* expression) {
	return MagickChannelFxImage((MagickWand*)wand, expression);
}

FFI_PLUGIN_EXPORT bool magickCharcoalImage(void* wand, const double radius, const double sigma) {
	return MagickCharcoalImage((MagickWand*)wand, radius, sigma) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickChopImage(void* wand, const size_t width, const size_t height, const ssize_t x, const ssize_t y) {
	return MagickChopImage((MagickWand*)wand, width, height, x, y) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickCLAHEImage(void* wand, const size_t width, const size_t height, const double number_bins, const double clip_limit) {
	return MagickCLAHEImage((MagickWand*)wand, width, height, number_bins, clip_limit) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClampImage(void* wand) {
	return MagickClampImage((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClipImage(void* wand) {
	return MagickClipImage((MagickWand*)wand) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClipImagePath(void* wand, const char* pathname, const bool inside) {
	return MagickClipImagePath((MagickWand*)wand, pathname, inside) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClutImage(void* wand, const void* clut_wand, const int method) {
	return MagickClutImage((MagickWand*)wand, (MagickWand*)clut_wand, method) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickCoalesceImages(void* wand) {
	return MagickCoalesceImages((MagickWand*)wand);
}

FFI_PLUGIN_EXPORT bool magickColorDecisionListImage(void* wand, const char* color_correction_collection) {
	return MagickColorDecisionListImage((MagickWand*)wand, color_correction_collection) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickColorizeImage(void* wand, const void* colorize, const void* blend) {
	return MagickColorizeImage((MagickWand*)wand, (PixelWand*)colorize, (PixelWand*)blend) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickColorMatrixImage(void* wand, const void* color_matrix) {
	return MagickColorMatrixImage((MagickWand*)wand, (KernelInfo*)color_matrix) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickColorThresholdImage(void* wand, const void* start_color, const void* stop_color) {
	return MagickColorThresholdImage((MagickWand*)wand, (PixelWand*)start_color, (PixelWand*)stop_color) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickCombineImages(void* wand, const int colorspace) {
	return MagickCombineImages((MagickWand*)wand, colorspace);
}

FFI_PLUGIN_EXPORT bool magickCommentImage(void* wand, const char* comment) {
	return MagickCommentImage((MagickWand*)wand, comment) == MagickTrue;
}

FFI_PLUGIN_EXPORT void* magickCompareImagesLayers(void* wand, const int method) {
	return MagickCompareImagesLayers((MagickWand*)wand, method);
}

FFI_PLUGIN_EXPORT void* magickCompareImages(void* wand, const void* reference, const int metric, double* distortion) {
	return MagickCompareImages((MagickWand*)wand, (MagickWand*)reference, metric, distortion);
}

FFI_PLUGIN_EXPORT void* magickComplexImages(void* wand, const int op) {
	return MagickComplexImages((MagickWand*)wand, op);
}

FFI_PLUGIN_EXPORT bool magickCompositeImage(void *wand, const void *source_wand,const int compose, const bool clip_to_self,const ssize_t x,const ssize_t y){
    return MagickCompositeImage((MagickWand*)wand, (MagickWand*)source_wand, compose, clip_to_self, x, y) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickCompositeImageGravity(void *wand, const void *source_wand,const int compose,const int gravity){
    return MagickCompositeImageGravity((MagickWand*)wand, (MagickWand*)source_wand, compose, gravity) == MagickTrue;
}

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT bool magickReadImage(void* wand, const char* filename) {
	return MagickReadImage((MagickWand*)wand, filename) == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickWriteImage(void* wand, const char* filename) {
	return MagickWriteImage((MagickWand*)wand, filename) == MagickTrue;
}