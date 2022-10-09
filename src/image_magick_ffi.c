#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>

void handleWandException(MagickWand* wand, char* errorOut, int maxErrorOutSize) {
	char* description;
	ExceptionType severity;
	description = MagickGetException(wand, &severity);
	strcpy_s(errorOut, maxErrorOutSize, description);
}

FFI_PLUGIN_EXPORT void resize(const char* inputFilePath, const char* outputFilePath, int width, int height, char* errorOut, int maxErrorOutSize) {
	MagickWandGenesis();

	MagickWand* m_wand = NULL;

	strcpy_s(errorOut, maxErrorOutSize, "");

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