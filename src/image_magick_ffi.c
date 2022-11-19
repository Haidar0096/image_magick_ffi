#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>

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

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT bool magickReadImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickReadImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickWriteImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickWriteImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}