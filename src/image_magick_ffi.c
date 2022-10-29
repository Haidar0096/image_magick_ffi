#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>

// include android log lib if android is defined
#ifdef ANDROID
#include <android/log.h>
#endif

void handleWandException(MagickWand* wand, char* errorOut, int maxErrorOutSize) {
	char* description;
	ExceptionType severity;
	description = MagickGetException(wand, &severity);
	#if defined(WIN32)
        strcpy_s(errorOut, maxErrorOutSize, description);
    #elif defined(UNIX)
        *errorOut = '\0';
    #endif
}

FFI_PLUGIN_EXPORT void resize(const char* inputFilePath, const char* outputFilePath, int width, int height, char* errorOut, int maxErrorOutSize) {
    #ifdef ANDROID
        __android_log_print(ANDROID_LOG_INFO, "ImageMagick", "resize called");
        // print quantum depth
        size_t* depthPtr = (size_t*)malloc(sizeof(size_t));
        const char* depthStringPtr = MagickGetQuantumDepth(depthPtr);
        free(depthPtr);
        __android_log_print(ANDROID_LOG_INFO,"ImageMagick","\ndepth is %s\n", depthStringPtr);
    #endif

	MagickWandGenesis();

	MagickWand* m_wand = NULL;

    #if defined(WIN32)
        strcpy_s(errorOut, maxErrorOutSize, "");
    #elif defined(UNIX)
        *errorOut = '\0';
    #endif


	m_wand = NewMagickWand();

	MagickBooleanType status = MagickTrue; // indicates success

	// Read the image
	status = MagickReadImage(m_wand, inputFilePath);
	if (!status) {
		handleWandException(m_wand, errorOut, maxErrorOutSize);
		return;
	}

	// make sure width and height don't underflow
	if (width < 1)width = 1;
	if (height < 1)height = 1;

	// Resize the image using the Lanczos filter
	// The blur factor is a "double", where > 1 is blurry, < 1 is sharp
	// I haven't figured out how you would change the blur parameter of MagickResizeImage
	// on the command line so I have set it to its default of one.
	status = MagickResizeImage(m_wand, width, height, LanczosFilter);
	if (!status) {
		handleWandException(m_wand, errorOut, maxErrorOutSize);
		return;
	}

	// Set the compression quality to 95 (high quality = low compression)
	MagickSetImageCompressionQuality(m_wand, 95);
	if (!status) {
		handleWandException(m_wand, errorOut, maxErrorOutSize);
		return;
	}

	/* Write the new image */
	MagickWriteImage(m_wand, outputFilePath);
	if (!status) {
		handleWandException(m_wand, errorOut, maxErrorOutSize);
		return;
	}

	/* Clean up */
	if (m_wand)m_wand = DestroyMagickWand(m_wand);


	MagickWandTerminus();
}