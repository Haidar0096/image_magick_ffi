
## 0.0.1-dev.1

* Initial development release.

## 0.0.1-dev.2

* Added new bindings and updated README.md to include showcase of the power of imagemagick.

## 0.0.1-dev.3 - January 19, 2023

* `initialize()` method is now called automatically when the app launches,  
  no need to call it manually.
* Updated README.md.
* Added new bindings for MagickWand methods.
* Removed the method `magickConstituteImageFromQuantumPixel`.

## 0.0.1-dev.4 - Jan 21, 2023 [Breaking Changes]

* [Breaking] `dispose` is now called `disposeImageMagick` to avoid naming conflicts.
* Added new bindings for MagickWand methods.
* Removed the plugin's dependency on Flutter.
* Fixed a bug that caused dependent apps to crash in release mode because some native data was not initialized in release mode.

## 0.0.1-dev.5 - Jan 21, 2023

* Fixed broken link in README.md.
* Corrected package's metadata.

## 0.0.1-dev.6 - Jan 21, 2023

* Added new bindings for MagickWand methods.
* Updated package's metadata.

## 0.0.1-dev.7 - Jan 23, 2023

* Added new bindings for MagickWand methods.
* Updated package's metadata.

## 0.0.1-dev.8 - Jan 27, 2023

* Added new bindings for MagickWand methods.
* Major refactor and improvements to the codebase.

## 0.0.1-dev.9 - Jan 28, 2023

* Added new bindings for MagickWand methods.
* Made `initializeImageMagick` public again to allow manual initialization of the library when used in a pure dart app.

## 0.0.1-dev.10 - Feb 14, 2023

* Added new bindings for MagickWand methods.
* Improved the codebase quality and documentation.

## 0.0.1-dev.11 - Date to be set

* Deprecated the plugin in favor of splitting it into the 4 variants:
  [image_magick_q8](https://pub.dev/packages/image_magick_q8),
  [image_magick_q8_hdri](https://pub.dev/packages/image_magick_q8_hdri),
  [image_magick_q16](https://pub.dev/packages/image_magick_q16),
  [image_magick_q16_hdri](https://pub.dev/packages/image_magick_q16_hdri).
  