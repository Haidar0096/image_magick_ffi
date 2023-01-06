// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_magick_ffi/image_magick_ffi.dart' as im; // use named import to avoid naming conflicts
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _inputFile;
  Directory? _outputDirectory = Directory("D:\\magick");
  int _outputImageWidth = 800;
  int _outputImageHeight = 600;

  bool isLoading = false;

  final TextEditingController _outputImageWidthController = TextEditingController();
  final TextEditingController _outputImageHeightController = TextEditingController();

  String? operationError;

  late im.MagickWand _wand;

  @override
  void initState() {
    im.initialize(); // initialize the plugin, this can be done before `runApp` as well
    _wand = im.MagickWand.newMagickWand(); // create a MagickWand to edit images

    File file = File("D:\\magick\\Screenshot.png");
    if (file.existsSync()) {
      _inputFile = file;
    }

    _outputImageWidthController.text = _outputImageWidth.toString();
    _outputImageHeightController.text = _outputImageHeight.toString();
    super.initState();
  }

  @override
  dispose() {
    _outputImageWidthController.dispose();
    _outputImageHeightController.dispose();
    _wand.destroyMagickWand(); // we are done with the wand
    im.dispose(); // we are done with the plugin
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_inputFile != null)
                    Image.file(
                      _inputFile!,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                  Text('input file: ${_inputFile?.path}'),
                  Text('output directory: ${_outputDirectory?.path}'),
                  Text('output image width: $_outputImageWidth'),
                  Text('output image height: $_outputImageHeight'),
                  Text('operation error: $operationError'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final filePickerResult = await FilePicker.platform
                          .pickFiles(allowedExtensions: ['jpg', 'jpeg', 'png'], type: FileType.custom);
                      if (filePickerResult != null) {
                        setState(() {
                          _inputFile = File(filePickerResult.files[0].path!);
                        });
                      }
                    },
                    child: const Text('pick input image'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final directoryPickerResult = await FilePicker.platform.getDirectoryPath();
                      if (directoryPickerResult != null) {
                        setState(() {
                          _outputDirectory = Directory(directoryPickerResult);
                        });
                      }
                    },
                    child: const Text('pick output directory'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'width',
                          ),
                          controller: _outputImageWidthController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _outputImageWidth = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'height',
                          ),
                          controller: _outputImageHeightController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _outputImageHeight = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      if (_inputFile == null) {
                        setState(() {
                          operationError = 'input file is null';
                        });
                        return;
                      }
                      if (_outputDirectory == null) {
                        setState(() {
                          operationError = 'output directory is null';
                        });
                        return;
                      }
                      if (_outputImageWidth <= 0) {
                        setState(() {
                          operationError = 'output image width is invalid';
                        });
                        return;
                      }
                      if (_outputImageHeight <= 0) {
                        setState(() {
                          operationError = 'output image height is invalid';
                        });
                        return;
                      }
                      // request permission if not granted
                      if (!await Permission.storage.request().isGranted) {
                        setState(() {
                          operationError = 'storage permission is not granted';
                        });
                        return;
                      }
                      final stopwatch = Stopwatch()..start();
                      operationError = await _handlePress();
                      stopwatch.stop();
                      print("operation time: ${stopwatch.elapsedMilliseconds}ms");
                      setState(() {});
                    },
                    child: const Text('Click Me!'),
                  ),
                  const SizedBox(height: 10),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // reads an image, then writes it in jpeg format
  Future<String?> _handlePress() async {
    try {
      setState(() => isLoading = true);

      await _wand.magickReadImage(_inputFile!.path); // read the image

      await _wand.magickAdaptiveResizeImage(_outputImageWidth, _outputImageHeight); // resize the image
      await _wand.magickAddNoiseImage(im.NoiseType.UniformNoise, 10); // add noise to the image

      final String ps = Platform.pathSeparator;
      final String inputFileNameWithoutExtension = _inputFile!.path.split(ps).last.split('.').first;
      final String outputFilePath = '${_outputDirectory!.path}${ps}out_$inputFileNameWithoutExtension.png';

      await _wand.magickWriteImage(outputFilePath); // write the image to a file in the png format

      im.MagickGetExceptionResult e = _wand.magickGetException(); // get the exception if any
      if (e.severity != im.ExceptionType.UndefinedException) {
        throw e.description;
      }

      setState(() => isLoading = false);
      return null;
    } catch (e) {
      setState(() => isLoading = false);
      return e.toString();
    }
  }
}
