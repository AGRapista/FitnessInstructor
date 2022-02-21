import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:isolate';

import 'main.dart';
import 'utility/classifier.dart';
import 'utility/isolate.dart';

import 'components/perform_components/utility.dart';
import '../components/manage_components/json_handler.dart';

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

  bool predicting = false;
  bool initialized = false;
  late List parsedData;
  late List<dynamic> inferences;

  // TEST VARIABLES
  double body_angle = 0;
  double arm_angle = 0;

  // WORKOUT AND WEEK DATA
  late JsonHandler jsonHandler;
  late List<dynamic> exercise;
  late String workout;
  late var dayToday;

  // DAY WORKOUT VARIABLES
  int workoutIndex = 0;
  String exerciseName = "";
  String imgUrl = "";
  int reps = 0;
  int sets = 0;

  // POSE AND FORM VALIDATION
  bool isProperForm = false;
  List<dynamic> limbs = [
    [
      [5, 7, 9],
      false
    ],
    [
      [6, 8, 10],
      false
    ],
    [
      [7, 5, 11],
      false
    ],
    [
      [8, 6, 12],
      false
    ],
    [
      [5, 11, 13],
      false
    ],
    [
      [6, 12, 14],
      false
    ],
    [
      [11, 13, 15],
      false
    ],
    [
      [12, 14, 16],
      false
    ],
  ];

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

    jsonHandler = JsonHandler();
    await jsonHandler.init();

    jsonHandler.workoutfileExists ? jsonHandler.fetchWorkouts() : null;
    jsonHandler.weekFileExists ? fetchDayWorkout() : null;
  }

  void fetchDayWorkout() {
    dayToday = DateTime.now();
    switch (dayToday.weekday) {
      case 1:
        dayToday = "Mon";
        break;
      case 2:
        dayToday = "Tues";
        break;
      case 3:
        dayToday = "Wed";
        break;
      case 4:
        dayToday = "Thurs";
        break;
      case 5:
        dayToday = "Fri";
        break;
      case 6:
        dayToday = "Sat";
        break;
      case 7:
        dayToday = "Sun";
        break;
    }
    jsonHandler.fetchWeekSchedule();

    print(dayToday);
    for (var day in jsonHandler.weekSchedule.keys) {
      print(dayToday.toString() +
          " " +
          day +
          " " +
          jsonHandler.weekSchedule[day]);
      if (dayToday == day) {
        setState(() {
          workout = jsonHandler.weekSchedule[day];
        });
      }
    }

    int index = int.parse(workout.substring(workout.length - 1)) - 1;
    exercise = jsonHandler.workouts[index]["workout_list"];

    // print("\n \n \nWORKOUT TODAY:" + workout);
    // print(exercise);
    getExerciseData();
  }

  void getExerciseData() {
    setState(() {
      imgUrl = exercise[workoutIndex]["exercise_image"];
      exerciseName = exercise[workoutIndex]["exercise_displayName"];
      reps = exercise[workoutIndex]["reps"];
      sets = exercise[workoutIndex]["sets"];
    });
  }

  void nextWorkout() {
    setState(() {
      workoutIndex += 1;
    });
    getExerciseData();
  }

  void loadCamera() {
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

  void createIsolate(CameraImage imageStream) async {
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

      int limbsIndex = 0;
      for (var limb in limbs) {
        var A = limb[0][0];
        var B = limb[0][1];
        var C = limb[0][2];
        pointA = [inferenceResults[A][0], inferenceResults[A][1]];
        pointB = [inferenceResults[B][0], inferenceResults[B][1]];
        pointC = [inferenceResults[C][0], inferenceResults[C][1]];
        if (getAngle(pointA, pointB, pointC) > 90) {
          limbs[limbsIndex][1] = true;
        } else {
          limbs[limbsIndex][1] = false;
        }
        limbsIndex += 1;
      }
    });

    // print(inferenceResults.toString());
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Text('Perform workoutss')),
            Image.asset('assets/img/shoulder_press_icon.png',
                width: 35, height: 35)
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: initialized
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      foregroundPainter: RenderLandmarks(inferences, limbs),
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
          Text(body_angle.toString(), style: TextStyle(fontSize: 30)),
          Row(
            children: [
              Text(exerciseName),
              Text(reps.toString()),
              Text(sets.toString()),
              FloatingActionButton(onPressed: nextWorkout),
            ],
          )
        ],
      ),
    );
  }
}

class RenderLandmarks extends CustomPainter {
  late List<dynamic> inferenceList;
  late PointMode pointMode;
  late List<dynamic> selectedLandmarks;

  // COLOR PROFILES

  // CORRECT POSTURE COLOR PROFILE
  var point_green = Paint()
    ..color = Colors.green
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  var edge_green = Paint()
    ..color = Colors.lightGreen
    ..strokeWidth = 5;

  // INCORRECT POSTURE COLOR PROFILE

  var point_red = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  var edge_red = Paint()
    ..color = Colors.orange
    ..strokeWidth = 5;

  List<Offset> points_green = [];
  List<Offset> points_red = [];

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
  RenderLandmarks(List<dynamic> inferences, List<dynamic> included) {
    inferenceList = inferences;
    selectedLandmarks = included;
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

    for (var limb in selectedLandmarks) {
      renderEdge(canvas, limb[0], limb[1]);
    }
    canvas.drawPoints(PointMode.points, points_green, point_green);
    canvas.drawPoints(PointMode.points, points_red, point_red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderEdge(Canvas canvas, List<int> included, bool isCorrect) {
    for (List<dynamic> point in inferenceList) {
      if ((point[2] > 0.40) & included.contains(inferenceList.indexOf(point))) {
        isCorrect
            ? points_green
                .add(Offset(point[0].toDouble() - 70, point[1].toDouble() - 30))
            : points_red.add(
                Offset(point[0].toDouble() - 70, point[1].toDouble() - 30));
      }
    }

    for (List<int> edge in edges) {
      if (included.contains(edge[0]) & included.contains(edge[1])) {
        double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
        double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
        double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
        double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
        canvas.drawLine(Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y),
            isCorrect ? edge_green : edge_red);
      }
    }
  }
}
