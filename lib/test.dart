import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:isolate';

import 'main.dart';
import 'utility/classifier.dart';
import 'utility/isolate.dart';

import 'components/perform_components/utility.dart';

class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  late Classifier classifier;
  late IsolateUtils isolate;

  late List parsedData;
  bool predicting = false;
  bool initialized = false;
  late List<dynamic> inferences;

  // TEST VARIABLES
  double body_angle = 0;
  double arm_angle = 0;

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
      initialized = true;

      // TEST CODE FOR BODY ANGLE
      // List<int> pointA = [inferenceResults[5][0], inferenceResults[5][1]];
      // List<int> pointB = [inferenceResults[11][0], inferenceResults[11][1]];
      // List<int> pointC = [inferenceResults[11][0] + 50, 0];

      List<int> pointA = [inferenceResults[5][0], inferenceResults[5][1]];
      List<int> pointB = [inferenceResults[7][0], inferenceResults[7][1]];
      List<int> pointC = [inferenceResults[9][0], inferenceResults[9][1]];
      body_angle = getAngle(pointA, pointB, pointC);
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
            child: initialized
                ? Container(
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
                  )
                : Container(),

            // RotatedBox(
            //     quarterTurns: 3,
            //     child: Image.memory(imageLib.encodeJpg(holder) as Uint8List))
          ),
          Text(body_angle.toString(), style: TextStyle(fontSize: 30))
        ],
      ),
    );
  }
}

class RenderLandmarks extends CustomPainter {
  late List<dynamic> inferenceList;
  late PointMode pointMode;
  var point_paint = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;
  var edge_paint = Paint()
    ..color = Colors.orange
    ..strokeWidth = 5;
  List<Offset> points = [];

  List<dynamic> edges = [
    [0, 1], // nose to left_eye
    [0, 2], // nose to right_eye
    [1, 3], // left_eye to left_ear
    [2, 4], // right_eye to right_ear
    [0, 5], // nose to left_shoulder
    [0, 6], // nose to right_shoulder
    [5, 7], // left_shoulder to left_elbow
    [7, 9], // left_elbow to left_wrist
    [6, 8], // right_shoulder to right_elbow
    [8, 10], // right_elbow to right_wrist
    [5, 6], // left_shoulder to right_shoulder
    [5, 11], // left_shoulder to left_hip
    [6, 12], // right_shoulder to right_hip
    [11, 12], // left_hip to right_hip
    [11, 13], // left_hip to left_knee
    [13, 15], // left_knee to left_ankle
    [12, 14], // right_hip to right_knee
    [14, 16] // right_knee to right_ankle
  ];
  RenderLandmarks(List<dynamic> inferences) {
    inferenceList = inferences;
  }
  @override
  void paint(Canvas canvas, Size size) {
    // for (List<int> edge in edges) {
    //   double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
    //   double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
    //   double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
    //   double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
    //   canvas.drawLine(
    //       Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), edge_paint);
    // }

    renderEdge(canvas, [5, 7, 9]);
    canvas.drawPoints(PointMode.points, points, point_paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderEdge(Canvas canvas, List<int> included) {
    for (List<dynamic> point in inferenceList) {
      if ((point[2] > 0.40) & included.contains(inferenceList.indexOf(point))) {
        points.add(Offset(point[0].toDouble() - 70, point[1].toDouble() - 30));
      }
    }

    for (List<int> edge in edges) {
      if (included.contains(edge[0]) & included.contains(edge[1])) {
        double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
        double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
        double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
        double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
        canvas.drawLine(
            Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), edge_paint);
      }
    }
  }
}
