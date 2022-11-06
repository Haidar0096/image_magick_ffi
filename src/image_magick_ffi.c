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

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT void magickWandGenesis(void) {
    MagickWandGenesis();
}

FFI_PLUGIN_EXPORT void magickWandTerminus(void) {
    MagickWandTerminus();
}

FFI_PLUGIN_EXPORT void *newMagickWand(void) {
    return NewMagickWand();
}

FFI_PLUGIN_EXPORT bool magickReadImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickReadImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}

FFI_PLUGIN_EXPORT bool magickWriteImage(void *wand, const char *filename) {
    MagickBooleanType result = MagickWriteImage((MagickWand *) wand, filename);
    return result == MagickTrue;
}