// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_magick_ffi/image_magick_ffi.dart' as magick_ffi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final File _inputFile = File('D:\\magick\\fayruz_love.png');
  final File _fastApiOutputFile = File('D:\\magick\\output_fast_api.png');
  static const int _outputImageWidth = 800;
  static const int _outputImageHeight = 600;

  String? _fastResizeResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Fast Resize Result: $_fastResizeResult'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Stopwatch stopwatch2 = Stopwatch()..start();
                  await _fastResize();
                  print('fastResize executed in ${stopwatch2.elapsed.inMilliseconds} millis');
                },
                child: const Text('resize', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fastResize() async {
    _fastResizeResult = await magick_ffi.resize(
      inputFilePath: _inputFile.path,
      outputFilePath: _fastApiOutputFile.path,
      width: _outputImageWidth,
      height: _outputImageHeight,
    );
    setState(() {});
  }

}
