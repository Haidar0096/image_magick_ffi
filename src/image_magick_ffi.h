#include <stdlib.h>
#include <stdbool.h>

#include <MagickCore/magick-baseconfig.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT void clearMagickWand(void *wand);

FFI_PLUGIN_EXPORT void *cloneMagickWand(const void *wand);

FFI_PLUGIN_EXPORT void *destroyMagickWand(void *wand);

FFI_PLUGIN_EXPORT bool isMagickWand(const void *wand);

FFI_PLUGIN_EXPORT bool magickClearException(void *wand);

FFI_PLUGIN_EXPORT char *magickGetException(const void *wand, int *severity);

FFI_PLUGIN_EXPORT int magickGetExceptionType(const void *wand);

FFI_PLUGIN_EXPORT ssize_t magickGetIteratorIndex(void *wand);

FFI_PLUGIN_EXPORT char *magickQueryConfigureOption(const char *option);

FFI_PLUGIN_EXPORT char **magickQueryConfigureOptions(const char *pattern, size_t *number_options);

FFI_PLUGIN_EXPORT double *magickQueryFontMetrics(void *wand, const void *drawing_wand, const char *text);

FFI_PLUGIN_EXPORT double *magickQueryMultilineFontMetrics(void *wand, const void *drawing_wand,const char *text);

FFI_PLUGIN_EXPORT char **magickQueryFonts(const char *pattern, size_t *number_fonts);

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT void magickWandGenesis(void);

FFI_PLUGIN_EXPORT void magickWandTerminus(void);

FFI_PLUGIN_EXPORT void *newMagickWand(void);

FFI_PLUGIN_EXPORT bool magickReadImage(void *wand, const char *filename);

FFI_PLUGIN_EXPORT bool magickWriteImage(void *wand, const char *filename);