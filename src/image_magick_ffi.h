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

FFI_PLUGIN_EXPORT char **magickQueryFormats(const char *pattern,size_t *number_formats);

FFI_PLUGIN_EXPORT void *magickRelinquishMemory(void *resource);

FFI_PLUGIN_EXPORT void magickResetIterator(void *wand);

FFI_PLUGIN_EXPORT void magickSetFirstIterator(void *wand);

FFI_PLUGIN_EXPORT bool magickSetIteratorIndex(void *wand, const ssize_t index);

FFI_PLUGIN_EXPORT void magickSetLastIterator(void *wand);

FFI_PLUGIN_EXPORT void magickWandGenesis(void);

FFI_PLUGIN_EXPORT void magickWandTerminus(void);

FFI_PLUGIN_EXPORT void *newMagickWand(void);

FFI_PLUGIN_EXPORT void *newMagickWandFromImage(const void *image);

FFI_PLUGIN_EXPORT bool isMagickWandInstantiated(void);

FFI_PLUGIN_EXPORT bool magickDeleteImageArtifact(void *wand, const char *artifact);

FFI_PLUGIN_EXPORT bool magickDeleteImageProperty(void *wand, const char *property);

FFI_PLUGIN_EXPORT bool magickDeleteOption(void *wand, const char *option);

FFI_PLUGIN_EXPORT bool magickGetAntialias(const void *wand);

FFI_PLUGIN_EXPORT void *magickGetBackgroundColor(void *wand);

FFI_PLUGIN_EXPORT int magickGetColorspace(void *wand);

FFI_PLUGIN_EXPORT int magickGetCompression(void *wand);

FFI_PLUGIN_EXPORT size_t magickGetCompressionQuality(void *wand);

FFI_PLUGIN_EXPORT const char *magickGetCopyright(void);

FFI_PLUGIN_EXPORT const char *magickGetFilename(const void *wand);

FFI_PLUGIN_EXPORT char *magickGetFont(void *wand);

FFI_PLUGIN_EXPORT const char *magickGetFormat(void *wand);

FFI_PLUGIN_EXPORT int magickGetGravity(void *wand);

FFI_PLUGIN_EXPORT char *magickGetHomeURL(void);

FFI_PLUGIN_EXPORT char *magickGetImageArtifact(void *wand,const char *artifact);

FFI_PLUGIN_EXPORT char **magickGetImageArtifacts(void *wand, const char *pattern,size_t *number_artifacts);

FFI_PLUGIN_EXPORT unsigned char *magickGetImageProfile(void *wand,const char *name, size_t *length);

FFI_PLUGIN_EXPORT char **magickGetImageProfiles(void *wand,const char *pattern, size_t *number_profiles);

// TODO: complete adding the other methods

FFI_PLUGIN_EXPORT bool magickReadImage(void *wand, const char *filename);

FFI_PLUGIN_EXPORT bool magickWriteImage(void *wand, const char *filename);