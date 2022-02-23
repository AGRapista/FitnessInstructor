import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:isolate';

import 'main.dart';
import 'utility/classifier.dart';
import 'utility/isolate.dart';

import 'components/shared/exerciseList.dart';
import 'components/perform_components/utility.dart';
import 'components/shared/json_handler.dart';
import 'components/shared/exercise_handler.dart';

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
  double test_angle1 = 0;
  double test_angle2 = 0;

  // WORKOUT AND WEEK DATA
  late JsonHandler jsonHandler;
  late List<dynamic> exercise;
  late String workout;
  late var dayToday;

  // DAY WORKOUT VARIABLES
  late var handler;

  int workoutIndex = 0;
  String exerciseName = "";
  String exerciseDisplayName = "";
  String imgUrl = "";
  int reps = 0;
  int sets = 0;

  int doneReps = 0;
  int doneSets = 0;
  var stage = "up";
  bool rest = false;
  int restTime = 0;

  // POSE AND FORM VALIDATION
  bool isProperForm = false;
  List<dynamic> limbs2 = [
    [
      [7, 5, 11],
      false,
      5,
      25
    ],
    // [
    //   [8, 6, 12],
    //   false,
    //   5,
    //   25
    // ],
    [
      [5, 11, 13],
      false,
      170,
      180
    ],
    // [
    //   [6, 12, 14],
    //   false,
    //   160,
    //   180
    // ],
    // [
    //   [11, 13, 15],
    //   false,
    //   170,
    //   180
    // ],
    // [
    //   [12, 14, 16],
    //   false,
    //   160,
    //   180
    // ],
  ];

  List<dynamic> targets = [
    [
      [5, 7, 9],
      false
    ],
    // [
    //   [6, 8, 10],
    //   false
    // ],
  ];

  List<dynamic> limbs = [];

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

    setState(() {
      limbs = handler.limbs;
      targets = handler.targets;
    });
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
      exerciseName = exercise[workoutIndex]["exercise_name"];
      imgUrl = exercise[workoutIndex]["exercise_image"];
      exerciseDisplayName = exercise[workoutIndex]["exercise_displayName"];
      reps = exercise[workoutIndex]["reps"];
      sets = exercise[workoutIndex]["sets"];
      handler = Exercises[exerciseName]!.handler;
      print(handler);
      handler.init();
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

  bool isPostureCorrect() {
    for (var limb in limbs) {
      if (limb[1] == false) {
        return false;
      }
    }
    return true;
  }

  void checkLimbs(var inferenceResults, var limbsIndex) {
    print("______________________________________");
    for (var limb in limbs) {
      var A = limb[0][0];
      var B = limb[0][1];
      var C = limb[0][2];
      List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
      List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
      List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
      var angle = getAngle(pointA, pointB, pointC);
      print(limb[0].toString() + " | " + angle.toString());
      if (angle >= limb[2] && angle <= limb[3]) {
        limbs[limbsIndex][1] = true;
      } else {
        limbs[limbsIndex][1] = false;
      }
      limbsIndex += 1;
    }
  }

  void doReps(var inferenceResults) {
    if (isProperForm) {
      var angle = 0.0;
      for (var target in targets) {
        var A = target[0][0];
        var B = target[0][1];
        var C = target[0][2];
        List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
        List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
        List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
        angle = getAngle(pointA, pointB, pointC);
        setState(() {
          test_angle1 = angle;
        });
      }
      if (angle < 30) {
        setState(() {
          stage = "down";
        });
      }
      if (angle > 160 && stage == "down") {
        setState(() {
          stage = "up";
          doneReps += 1;
        });
      }
    }
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

      List<int> pointA = [inferenceResults[7][0], inferenceResults[7][1]];
      List<int> pointB = [inferenceResults[5][0], inferenceResults[5][1]];
      List<int> pointC = [inferenceResults[11][0], inferenceResults[11][1]];
      test_angle2 = getAngle(pointA, pointB, pointC);

      int limbsIndex = 0;

      //   if (!rest) {
      //     if (doneSets < sets) {
      //       if (doneReps < reps) {
      //         checkLimbs(inferenceResults, limbsIndex);
      //         isProperForm = isPostureCorrect();
      //         doReps(inferenceResults);
      //       } else {
      //         setState(() {
      //           doneReps = 0;
      //           doneSets++;
      //           rest = true;
      //           restTime = 30;
      //         });
      //       }
      //     } else {
      //       setState(() {
      //         doneSets = 0;
      //         doneReps = 0;
      //         nextWorkout();
      //         rest = true;
      //         restTime = 60;
      //       });
      //     }
      //   } else {
      //     setState(() {
      //       restTime = 0;
      //       rest = false;
      //     });
      //   }
      // });

      if (!rest) {
        if (handler.doneSets < sets) {
          if (handler.doneReps < reps) {
            handler.checkLimbs(inferenceResults, limbsIndex);
            isProperForm = handler.isPostureCorrect();
            handler.doReps(inferenceResults);
            setState(() {
              doneReps = handler.doneReps;
              stage = handler.stage;
              test_angle1 = handler.angle;
            });
          } else {
            handler.doneReps = 0;
            handler.doneSets++;
            setState(() {
              doneReps = handler.doneReps;
              doneSets = handler.doneSets;
              rest = true;
              restTime = 30;
            });
          }
        } else {
          handler.doneSets = 0;
          handler.doneReps = 0;
          setState(() {
            doneReps = handler.doneReps;
            doneSets = handler.doneSets;
            nextWorkout();
            rest = true;
            restTime = 60;
          });
        }
      } else {
        setState(() {
          restTime = 0;
          rest = false;
        });
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
                child: Text('Perform workouts')),
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
          Row(
            children: [
              Text(doneReps.toString(), style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 10,
              ),
              Text(doneSets.toString(), style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 10,
              ),
              Text(isProperForm.toString(), style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 10,
              ),
              Text(stage.toString(), style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 10,
              ),
              Text(test_angle1.toString(), style: TextStyle(fontSize: 30))
            ],
          ),
          Text(test_angle2.toString(), style: TextStyle(fontSize: 30)),
          Row(
            children: [
              Text(exerciseName),
              Text(reps.toString()),
              Text(sets.toString()),
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
