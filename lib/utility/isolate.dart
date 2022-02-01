import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;
import 'classifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateUtils {
  static const String DEBUG_NAME = "InferenceIsolate";

  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      if (isolateData != null) {
        Classifier classifier = Classifier(
            interpreter:
                Interpreter.fromAddress(isolateData.interpreterAddress));
        classifier.performOperations(isolateData.cameraImage);
        classifier.runModel();
        List<dynamic> results = classifier.parseLandmarkData();
        isolateData.responsePort.send(results);
      }
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  late SendPort responsePort;

  IsolateData(this.cameraImage, this.interpreterAddress);
}
