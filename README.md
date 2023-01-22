# ⚠️Attention⚠️

This is not a stable release. It is a development release for beta-testers to try out the plugin and
report bugs. It is not recommended to use this plugin in production apps yet.

# Table Of Contents

- [Table Of Contents](#table-of-contents)
- [Contributors](#contributors)
- [ImageMagickFFi Plugin](#imagemagickffi-plugin)
  - [Feel Native](#feel-native)
  - [What Can It Do?](#what-can-it-do)
- [Install](#install)
- [Setup](#setup)
- [Usage](#usage)
- [Contributing](#contributing)

# Contributors

Special thanks to [Piero5W11](https://github.com/Piero512) for being the "FFI Master" and helping me
a lot with this plugin.

# ImageMagickFFi Plugin

This plugin brings to you the [ImageMagick](https://imagemagick.org/) C
library [MagickWand](https://imagemagick.org/script/magick-wand.php) to use with dart.

## Feel Native

Interact with the underlying ImageMagick C api just as you used to do in C (not with pointers, of
course :P).

## What Can It Do?

See for yourself from this image from ImageMagick's website some of the things you can do with this
plugin:    
![ImageMagick](https://imagemagick.org/image/examples.jpg)

Have a look the #Usage section below for more insights.

# Install

`image_magick_ffi: <latest_version>`

# Setup

- Currently there are 4 variants of the ImageMagick library that come with this plugin: Q8, Q16,    
  Q8-HDRI, and Q16-HDRI.
- You can choose which one you want to use.
- Your decision must be made at the build-time (not runtime) of your project.
- No need to worry about the files of other variants that you didn't choose in the previous
  step,    
  only the files of the variant you had chosen will be bundled with your app when you build your    
  app.
- #### Windows
  - Windows x64 (32 bits) and window x86 (32 bits) are both supported.
  - To choose one of the variants add this to your `windows/CMakeLists.txt` file:

 ```    
 # Use ImageMagick with Q8 and HDRI enabled.  
set(Q8 1) set(HDRI 1) 
```

**Note**:

- Do not try to `set(Q8 1)` and `set(Q16 1)` at the same time, or an error will occur.
- If you don't set any configuration then by default "Q8-No HDRI" will be used.
- Make sure you add the snippet above before this    
  line `include(flutter/generated_plugins.cmake)`
- #### Android
  Currently only arm64-v8a (64 bits) is supported. If you want to help add support to armeabi-v7a (
  32 bits), have a look [here](https://github.com/MolotovCherry/Android-ImageMagick7/discussions/95)
  .

  To choose one of the variants add this to your **`android/build.gradle`** file as a top-level
  statement:

```    
// Use ImageMagick with Q16 and HDRI enabled.   
ext { Q16 = 1 HDRI = 1 }
 ``` 

Also note that you might need to get write permissions from the system  
for some operations as writing an image.

- #### Linux
  Coming Soon (for sure)
- #### Macos
  Your contributions to provide the binaries are welcomed :)
- #### IOS
  Your contributions to provide the binaries are welcomed :)

# Usage

## Initialize the plugin

```dart @override void initState() {    
 _wand = MagickWand.newMagickWand(); // create a MagickWand to edit images    
 // set a callback to be called when image processing progress changes
 WidgetsBinding.instance.addPostFrameCallback( (timeStamp) async => await _wand.magickSetProgressMonitor( (info, offset, size, clientData) => setState(() => status = '[${info .split('/') .first}, $offset, $size, $clientData]'), ), );    
super.initState();}
 ```   

## Use the plugin

```dart
void _doSomeOperations() async {
  await _wand.magickReadImage(_inputFile!.path); // read the image
  _throwWandExceptionIfExists(_wand); // see below

  ///////////////////////// Do Some Operations On The Wand /////////////////////////

  // resize the image
  await _wand.magickAdaptiveResizeImage(1200, 800);
  _throwWandExceptionIfExists(_wand);
  // flip the image
  await _wand.magickFlipImage();
  _throwWandExceptionIfExists(_wand);
  // enhance the image
  await _wand.magickEnhanceImage();
  _throwWandExceptionIfExists(_wand);
  // add noise to the image
  await _wand.magickAddNoiseImage(NoiseType.GaussianNoise, 1.5);
  _throwWandExceptionIfExists(_wand);

  /////////////////////////////////////////////////////////////////////////////////

  String outputFilePath = _getOutputFilePath();

  await _wand.magickWriteImage(
          outputFilePath); // write the image to a file in the png format
  _throwWandExceptionIfExists(_wand);
}

void _throwWandExceptionIfExists(MagickWand wand) {
  MagickGetExceptionResult e =
  _wand.magickGetException(); // get the exception if any
  if (e.severity != ExceptionType.UndefinedException) {
    throw e;
  }
}
```   

## Dispose the plugin

```dart
@override
dispose() {
  _wand.destroyMagickWand(); // we are done with the wand 
  disposeImageMagick(); // we are done with the whole plugin
  super.dispose();
}
```

- For more info about code usage, have a look at the example app in this repo, there is a
  complete    
  working app there that is ready for you to play around with.
- Also check out
  - [The official ImageMagick website](https://imagemagick.org/).
  - [ImageMagick usage documentation](https://imagemagick.org/Usage/).
  - [Fred's ImageMagick scripts](http://www.fmwconcepts.com/imagemagick/index.php).
  - [Snibgo's examples](http://im.snibgo.com/).

# Contributing

- Feel free to open an issue if you have any problem or suggestion.
- Feel free to open a pull request if you want to contribute.