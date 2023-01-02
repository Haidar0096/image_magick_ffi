#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>
#include "dart_api_dl.h"
#include <json.h>

/*########################################## Dart Sdk Api ############################################*/
FFI_PLUGIN_EXPORT intptr_t initDartAPI(void* data){
    return Dart_InitializeApiDL(data);
}
/*########################################## Dart Sdk Api ############################################*/

FFI_PLUGIN_EXPORT void clearMagickWand(void *wand) {
    ClearMagickWand((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT void *cloneMagickWand(const void *wand) {
    return CloneMagickWand((const MagickWand *) wand);
}

FFI_PLUGIN_EXPORT void *destroyMagickWand(void *wand) {
    return DestroyMagickWand((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT bool isMagickWand(const void *wand) {
    MagickBooleanType result = IsMagickWand((const MagickWand *) wand);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickClearException(void *wand) {
    MagickBooleanType result = MagickClearException((MagickWand *) wand);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT char *magickGetException(const void *wand, int *severity) {
    return MagickGetException((const MagickWand *) wand, (ExceptionType *) severity);
}

FFI_PLUGIN_EXPORT int magickGetExceptionType(const void *wand) {
    return MagickGetExceptionType((const MagickWand *) wand);
}

FFI_PLUGIN_EXPORT ssize_t magickGetIteratorIndex(void *wand){
    return MagickGetIteratorIndex((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT char *magickQueryConfigureOption(const char *option){
    return MagickQueryConfigureOption(option);
}

FFI_PLUGIN_EXPORT char **magickQueryConfigureOptions(const char *pattern, size_t *number_options){
    return MagickQueryConfigureOptions(pattern, number_options);
}

FFI_PLUGIN_EXPORT double *magickQueryFontMetrics(void *wand, const void *drawing_wand, const char *text){
    return MagickQueryFontMetrics((MagickWand *) wand, (DrawingWand *) drawing_wand, text);
}

FFI_PLUGIN_EXPORT double *magickQueryMultilineFontMetrics(void *wand, const void *drawing_wand,const char *text){
    return MagickQueryMultilineFontMetrics((MagickWand *) wand, (DrawingWand *) drawing_wand, text);
}

FFI_PLUGIN_EXPORT char **magickQueryFonts(const char *pattern, size_t *number_fonts){
    return MagickQueryFonts(pattern, number_fonts);
}

FFI_PLUGIN_EXPORT char **magickQueryFormats(const char *pattern,size_t *number_formats){
    return MagickQueryFormats(pattern, number_formats);
}

FFI_PLUGIN_EXPORT void *magickRelinquishMemory(void *resource){
    return MagickRelinquishMemory(resource);
}

FFI_PLUGIN_EXPORT void magickResetIterator(void *wand){
    MagickResetIterator((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT void magickSetFirstIterator(void *wand){
    MagickSetFirstIterator((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT bool magickSetIteratorIndex(void *wand, const ssize_t index){
    MagickBooleanType result = MagickSetIteratorIndex((MagickWand *) wand, index);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT void magickSetLastIterator(void *wand){
    MagickSetLastIterator((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT void magickWandGenesis(void) {
    MagickWandGenesis();
}

FFI_PLUGIN_EXPORT void magickWandTerminus(void) {
    MagickWandTerminus();
}

FFI_PLUGIN_EXPORT void *newMagickWand(void) {
    return NewMagickWand();
}

FFI_PLUGIN_EXPORT void *newMagickWandFromImage(const void *image){
    return NewMagickWandFromImage((const Image *) image);
}

FFI_PLUGIN_EXPORT bool isMagickWandInstantiated(void){
    MagickBooleanType result = IsMagickWandInstantiated();
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteImageArtifact(void *wand, const char *artifact){
    MagickBooleanType result = MagickDeleteImageArtifact((MagickWand *) wand, artifact);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteImageProperty(void *wand, const char *property){
    MagickBooleanType result = MagickDeleteImageProperty((MagickWand *) wand, property);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickDeleteOption(void *wand, const char *option){
    MagickBooleanType result = MagickDeleteOption((MagickWand *) wand, option);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickGetAntialias(const void *wand){
    MagickBooleanType result = MagickGetAntialias((const MagickWand *) wand);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT void *magickGetBackgroundColor(void *wand){
    return MagickGetBackgroundColor((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT int magickGetColorspace(void *wand){
    return MagickGetColorspace((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT int magickGetCompression(void *wand){
    return MagickGetCompression((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT size_t magickGetCompressionQuality(void *wand){
    return MagickGetCompressionQuality((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT const char *magickGetCopyright(void){
    return MagickGetCopyright();
}

FFI_PLUGIN_EXPORT const char *magickGetFilename(const void *wand){
    return MagickGetFilename((const MagickWand *) wand);
}

FFI_PLUGIN_EXPORT char *magickGetFont(void *wand){
    return MagickGetFont((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT const char *magickGetFormat(void *wand){
    return MagickGetFormat((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT int magickGetGravity(void *wand){
    return MagickGetGravity((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT char *magickGetHomeURL(void){
    return MagickGetHomeURL();
}

FFI_PLUGIN_EXPORT char *magickGetImageArtifact(void *wand,const char *artifact){
    return MagickGetImageArtifact((MagickWand *) wand, artifact);
}

FFI_PLUGIN_EXPORT char **magickGetImageArtifacts(void *wand, const char *pattern, size_t *number_artifacts){
    return MagickGetImageArtifacts((MagickWand *) wand, pattern, number_artifacts);
}

FFI_PLUGIN_EXPORT unsigned char *magickGetImageProfile(void *wand,const char *name, size_t *length){
    return MagickGetImageProfile((MagickWand *) wand, name, length);
}

FFI_PLUGIN_EXPORT char **magickGetImageProfiles(void *wand,const char *pattern, size_t *number_profiles){
    return MagickGetImageProfiles((MagickWand *) wand, pattern, number_profiles);
}

FFI_PLUGIN_EXPORT char *magickGetImageProperty(void *wand,const char *property){
    return MagickGetImageProperty((MagickWand *) wand, property);
}

FFI_PLUGIN_EXPORT char **magickGetImageProperties (void *wand, const char *pattern, size_t *number_properties){
    return MagickGetImageProperties((MagickWand *) wand, pattern, number_properties);
}

FFI_PLUGIN_EXPORT int magickGetInterlaceScheme(void *wand){
    return MagickGetInterlaceScheme((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT int magickGetInterpolateMethod(void *wand){
    return MagickGetInterpolateMethod((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT char *magickGetOption(void *wand,const char *key){
    return MagickGetOption((MagickWand *) wand, key);
}

FFI_PLUGIN_EXPORT char **magickGetOptions(void *wand,const char *pattern, size_t *number_options){
    return MagickGetOptions((MagickWand *) wand, pattern, number_options);
}

FFI_PLUGIN_EXPORT int magickGetOrientation(void *wand){
    return MagickGetOrientation((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT const char *magickGetPackageName(void){
    return MagickGetPackageName();
}

FFI_PLUGIN_EXPORT bool magickGetPage(const void *wand, size_t *width, size_t *height, ssize_t *x, ssize_t *y){
    MagickBooleanType result = MagickGetPage((const MagickWand *) wand, width, height, x, y);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT double magickGetPointsize(void *wand){
    return MagickGetPointsize((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT const char *magickGetQuantumDepth(size_t *depth){
    return MagickGetQuantumDepth(depth);
}

FFI_PLUGIN_EXPORT const char *magickGetQuantumRange(size_t *range){
    return MagickGetQuantumRange(range);
}

FFI_PLUGIN_EXPORT const char *magickGetReleaseDate(void){
    return MagickGetReleaseDate();
}

FFI_PLUGIN_EXPORT bool magickGetResolution(const void *wand,double *x, double *y){
    MagickBooleanType result = MagickGetResolution((const MagickWand *) wand, x, y);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT unsigned long long magickGetResource(const int type){
    return MagickGetResource(type);
}

FFI_PLUGIN_EXPORT unsigned long long magickGetResourceLimit(const int type){
    return MagickGetResourceLimit(type);
}

FFI_PLUGIN_EXPORT double *magickGetSamplingFactors(void *wand, size_t *number_factors){
    return MagickGetSamplingFactors((MagickWand *) wand, number_factors);
}

FFI_PLUGIN_EXPORT bool magickGetSize(const void *wand, size_t *columns,size_t *rows){
    MagickBooleanType result = MagickGetSize((const MagickWand *) wand, columns, rows);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickGetSizeOffset(const void *wand, ssize_t *offset){
    MagickBooleanType result = MagickGetSizeOffset((const MagickWand *) wand, offset);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT int magickGetType(void *wand){
    return MagickGetType((MagickWand *) wand);
}

FFI_PLUGIN_EXPORT const char *magickGetVersion(size_t *version){
    return MagickGetVersion(version);
}

FFI_PLUGIN_EXPORT bool magickProfileImage(void *wand,const char *name, const void *profile,const size_t length){
    MagickBooleanType result = MagickProfileImage((MagickWand *) wand, name, profile, length);
    return result;
}

FFI_PLUGIN_EXPORT unsigned char *magickRemoveImageProfile(void *wand, const char *name,size_t *length){
    return MagickRemoveImageProfile((MagickWand *) wand, name, length);
}

FFI_PLUGIN_EXPORT bool magickSetAntialias(void *wand, const bool antialias){
    MagickBooleanType result = MagickSetAntialias((MagickWand *) wand, antialias);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetBackgroundColor(void *wand, const void *background){
    // TODO: test this when PixelWand is implemented in dart
    MagickBooleanType result = MagickSetBackgroundColor((MagickWand *) wand, (const PixelWand *) background);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetColorspace(void *wand, const int colorspace){
    MagickBooleanType result = MagickSetColorspace((MagickWand *) wand, colorspace);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetCompression(void *wand, const int compression){
    MagickBooleanType result = MagickSetCompression((MagickWand *) wand, compression);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetCompressionQuality(void *wand, const size_t quality){
    MagickBooleanType result = MagickSetCompressionQuality((MagickWand *) wand, quality);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetDepth(void *wand, const size_t depth){
    MagickBooleanType result = MagickSetDepth((MagickWand *) wand, depth);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetExtract(void *wand, const char *geometry){
    MagickBooleanType result = MagickSetExtract((MagickWand *) wand, geometry);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFilename(void *wand, const char *filename){
    MagickBooleanType result = MagickSetFilename((MagickWand *) wand, filename);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFont(void *wand, const char *font){
    MagickBooleanType result = MagickSetFont((MagickWand *) wand, font);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetFormat(void *wand,const char *format){
    MagickBooleanType result = MagickSetFormat((MagickWand *) wand, format);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetGravity(void *wand, const int type){
    MagickBooleanType result = MagickSetGravity((MagickWand *) wand, type);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageArtifact(void *wand, const char *artifact,const char *value){
    MagickBooleanType result = MagickSetImageArtifact((MagickWand *) wand, artifact, value);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageProfile(void *wand, const char *name,const void *profile,const size_t length){
    MagickBooleanType result = MagickSetImageProfile((MagickWand *) wand, name, profile, length);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetImageProperty(void *wand, const char *property,const char *value){
    MagickBooleanType result = MagickSetImageProperty((MagickWand *) wand, property, value);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetInterlaceScheme(void *wand, const int interlace_scheme){
    MagickBooleanType result = MagickSetInterlaceScheme((MagickWand *) wand, interlace_scheme);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetInterpolateMethod(void *wand, const int method){
    MagickBooleanType result = MagickSetInterpolateMethod((MagickWand *) wand, method);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetOption(void *wand,const char *key, const char *value){
    MagickBooleanType result = MagickSetOption((MagickWand *) wand, key, value);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetOrientation(void *wand, const int orientation){
    MagickBooleanType result = MagickSetOrientation((MagickWand *) wand, orientation);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPage(void *wand, const size_t width,const size_t height,const ssize_t x, const ssize_t y){
    MagickBooleanType result = MagickSetPage((MagickWand *) wand, width, height, x, y);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPassphrase(void *wand, const char *passphrase){
    MagickBooleanType result = MagickSetPassphrase((MagickWand *) wand, passphrase);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickSetPointsize(void *wand, const double pointsize){
    MagickBooleanType result = MagickSetPointsize((MagickWand *) wand, pointsize);
    return result == MagickTrue;
}

json_object* progressInfoToJsonObject(const char* text, const MagickOffsetType offset, const MagickSizeType size, void* clientData, int clientDataCount, int clientDataSize) {
	const char* infoKey = "info";
	const char* sizeKey = "size";
	const char* offsetKey = "offset";
	const char* clientDataKey = "client_data";

	json_object* jobj = json_object_new_object();
	json_object_object_add(jobj, infoKey, json_object_new_string(text));
	json_object_object_add(jobj, sizeKey, json_object_new_uint64(size));
	json_object_object_add(jobj, offsetKey, json_object_new_int64(offset));
	if (clientData != NULL)
	{
		json_object* clientDataJsonObj = json_object_new_array_ext(clientDataCount);
		for (int i = 0; i < clientDataCount; i++) {
			json_object_array_add(clientDataJsonObj, json_object_new_string_len((unsigned char*)clientData + i * clientDataSize, clientDataSize));
		}
		json_object_object_add(jobj, clientDataKey, clientDataJsonObj);
	}
	return jobj;
}

MagickBooleanType progressMonitor(const char* text, const MagickOffsetType offset, const MagickSizeType size, void* clientData) {
    json_object* jobj = progressInfoToJsonObject(text, offset, size, NULL, 0, 0);
    intptr_t sendPort = *((intptr_t*)clientData);
    Dart_CObject* message = malloc(sizeof *message);
    message->type = Dart_CObject_kString;
    message->value.as_string = json_object_to_json_string_ext(jobj, JSON_C_TO_STRING_PRETTY); // TODO: check if sending a const char* here will cause a problem
    Dart_PostCObject_DL(sendPort, message);
    json_object_put(jobj);
    free(message);
    return MagickTrue; // TODO: find a way to get the dart's method return value and return it here to support canceling
}


FFI_PLUGIN_EXPORT intptr_t* magickSetProgressMonitorPort(void *wand, intptr_t sendPort){
    intptr_t* sendPortPtr = malloc(sizeof *sendPortPtr);
    *sendPortPtr = sendPort;
    MagickSetProgressMonitor((MagickWand *) wand, progressMonitor, sendPortPtr);
    return sendPortPtr;
}

// TODO: complete adding the other methods
// TODO: download files from github instead of using the local files for C and header files and dlls

FFI_PLUGIN_EXPORT bool magickReadImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickReadImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickWriteImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickWriteImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}