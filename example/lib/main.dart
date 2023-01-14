// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_magick_ffi/image_magick_ffi.dart'
    as im; // use named import to avoid naming conflicts
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
  File? _outputFile;
  bool isLoading = false;

  String status = 'Idle';

  late im.MagickWand _wand;

  @override
  void initState() {
    im.initialize(); // initialize the plugin, this can be done before `runApp` as well
    _wand = im.MagickWand.newMagickWand(); // create a MagickWand to edit images

    final File file = File("D:\\magick\\screenshot.png");
    if (file.existsSync()) {
      _inputFile = file;
    }

    // set a callback to be called when image processing progress changes
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async => await _wand.magickSetProgressMonitor(
    //     (info, offset, size, clientData) => print('Progress: $info, $offset, $size, $clientData')));

    super.initState();
  }

  @override
  dispose() {
    _wand.destroyMagickWand(); // we are done with the wand
    im.dispose(); // we are done with the plugin
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Builder(builder: (context) {
          final double displayImageWidth =
              MediaQuery.of(context).size.width / 2.5;
          final double displayImageHeight =
              MediaQuery.of(context).size.height / 2.5;
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text("Input Image",
                                  style: TextStyle(fontSize: 20)),
                              if (_inputFile != null)
                                Text(_inputFile!.path,
                                    style: const TextStyle(fontSize: 20)),
                              _inputFile != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Image.memory(
                                        _inputFile!.readAsBytesSync(),
                                        width: displayImageWidth,
                                        height: displayImageHeight,
                                      ),
                                    )
                                  : Container(
                                      width: displayImageWidth,
                                      height: displayImageHeight,
                                      color: Colors.grey,
                                      child: const Center(
                                          child: Text('No image selected')),
                                    ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              const Text("Output Image",
                                  style: TextStyle(fontSize: 20)),
                              if (_outputFile != null)
                                Text(_outputFile!.path,
                                    style: const TextStyle(fontSize: 20)),
                              _outputFile != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Image.memory(
                                        _outputFile!.readAsBytesSync(),
                                        width: displayImageWidth,
                                        height: displayImageHeight,
                                      ),
                                    )
                                  : Container(
                                      width: displayImageWidth,
                                      height: displayImageHeight,
                                      color: Colors.grey,
                                      child: const Center(
                                          child: Text('No image selected')),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Status: $status',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final filePickerResult = await FilePicker.platform
                                .pickFiles(
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                    type: FileType.custom);
                            if (filePickerResult != null) {
                              setState(() {
                                _inputFile =
                                    File(filePickerResult.files[0].path!);
                              });
                            }
                          },
                          child: const Text('pick input image'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final directoryPickerResult =
                                await FilePicker.platform.getDirectoryPath();
                            if (directoryPickerResult != null) {
                              setState(() {
                                _outputDirectory =
                                    Directory(directoryPickerResult);
                              });
                            }
                          },
                          child: const Text('pick output directory'),
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
                                  status = 'Error: input file is null';
                                });
                                return;
                              }
                              if (_outputDirectory == null) {
                                setState(() {
                                  status = 'Error: output directory is null';
                                });
                                return;
                              }
                              // request permission if not granted
                              if (!await Permission.storage
                                  .request()
                                  .isGranted) {
                                setState(() {
                                  status =
                                      'Error: storage permission is not granted';
                                });
                                return;
                              }
                              final stopwatch = Stopwatch()..start();
                              status = await _handlePress();
                              stopwatch.stop();
                              print(
                                  "operation time: ${stopwatch.elapsedMilliseconds}ms");
                              setState(() {});
                            },
                      child: const Text('Start Processing'),
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

  // reads an image, then writes it in jpeg format
  Future<String> _handlePress() async {
    try {
      setState(() => isLoading = true);

      await _wand.magickReadImage(_inputFile!.path); // read the image

      ///////////////////////// Do Some Operations On The Wand /////////////////////////

      im.KernelInfo kernel = im.KernelInfo(
        width: 3,
        height: 3,
        values: [1, 0, 1, 0, 1, 0, 1, 0, 1],
      );
      await _wand.magickColorMatrixImage(
          colorMatrix: kernel); // apply color matrix to image
      await _wand.magickAdaptiveResizeImage(600, 800); // resize image
      await _wand.magickContrastImage(true); // apply contrast to image

      ///////////////////////////////////////////////////////////////////////////////////

      final String ps = Platform.pathSeparator;
      final String inputFileNameWithoutExtension =
          _inputFile!.path.split(ps).last.split('.').first;
      final String outputFilePath =
          '${_outputDirectory!.path}${ps}out_$inputFileNameWithoutExtension.png';

      await _wand.magickWriteImage(
          outputFilePath); // write the image to a file in the png format

      im.MagickGetExceptionResult e =
          _wand.magickGetException(); // get the exception if any
      if (e.severity != im.ExceptionType.UndefinedException) {
        throw e.description;
      }
      setState(() {
        _outputFile = File(outputFilePath);
        isLoading = false;
      });
      return 'Operation Successful!';
    } catch (e) {
      setState(() {
        _outputFile = null;
        isLoading = false;
      });
      return 'Error: ${e.toString()}';
    }
  }
}
