import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:isolate';

import 'main.dart';
import 'classifier.dart';
import 'isolate.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  late Classifier classifier;
  late IsolateUtils isolate;

  late List parsedData;
  bool predicting = false;
  late List<dynamic> inferences;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    classifier.loadModel();
    loadCamera();
  }

  loadCamera() {
    setState(() {
      cameraController = CameraController(cameras![1], ResolutionPreset.medium);
    });
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        cameraController!.startImageStream((imageStream) {
          createIsolate(imageStream);
        });
      }
    });
  }

  createIsolate(CameraImage imageStream) async {
    if (predicting == true) {
      return;
    }

    setState(() {
      predicting = true;
    });

    var isolateData = IsolateData(imageStream, classifier.interpreter.address);
    List<dynamic> inferenceResults = await inference(isolateData);

    setState(() {
      inferences = inferenceResults;
      predicting = false;
    });

    print(inferenceResults.toString());
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                foregroundPainter: RenderLandmarks(inferences),
                child: !cameraController!.value.isInitialized
                    ? Container()
                    : AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      ),
              ),
            ),

            // RotatedBox(
            //     quarterTurns: 3,
            //     child: Image.memory(imageLib.encodeJpg(holder) as Uint8List))
          )
        ],
      ),
    );
  }
}

class RenderLandmarks extends CustomPainter {
  late List<dynamic> inferenceList;
  late PointMode pointMode;
  var paint1 = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;
  List<Offset> points = [];
  List<dynamic> edges = [
    [0, 1],
    [0, 2],
    [1, 3],
    [2, 4],
    [0, 5],
    [0, 6],
    [5, 7],
    [7, 9],
    [6, 8],
    [8, 10],
    [5, 6],
    [5, 11],
    [6, 12],
    [11, 12],
    [11, 13],
    [13, 15],
    [12, 14],
    [14, 16]
  ];
  RenderLandmarks(List<dynamic> inferences) {
    inferenceList = inferences;
  }
  @override
  void paint(Canvas canvas, Size size) {
    for (List<dynamic> point in inferenceList) {
      if (point[2] > 40) {
        points.add(Offset(point[0].toDouble() - 70, point[1].toDouble() - 30));
      }
    }
    canvas.drawPoints(PointMode.points, points, paint1);
    for (List<int> edge in edges) {
      double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
      double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
      double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
      double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
      canvas.drawLine(
          Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), paint1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
