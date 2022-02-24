import 'dart:ffi';
import '../perform_components/utility.dart';

class ExerciseHandler {
  late List<dynamic> limbs;
  late List<dynamic> targets;

  late bool isProperForm;
  late int doneReps;
  late int doneSets;

  late var stage;
  late double angle;

  bool isPostureCorrect() {
    for (var limb in limbs) {
      if (limb[1] == false) {
        return false;
      }
    }
    return true;
  }

  void checkLimbs(var inferenceResults, var limbsIndex) {
    for (var limb in limbs) {
      var A = limb[0][0];
      var B = limb[0][1];
      var C = limb[0][2];

      List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
      List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
      List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];

      var angle = getAngle(pointA, pointB, pointC);

      if (angle >= limb[2] && angle <= limb[3]) {
        limbs[limbsIndex][1] = true;
      } else {
        limbs[limbsIndex][1] = false;
      }
      limbsIndex += 1;
    }
  }
}

// Dumbell Curl Handler

class DumbellCurlHandler extends ExerciseHandler {
  void init() {
    limbs = [
      [
        [7, 5, 11],
        false,
        5,
        25
      ],
      [
        [5, 11, 13],
        false,
        170,
        180
      ],
    ];
    targets = [
      [
        [5, 7, 9],
        false
      ],
    ];

    doneReps = 0;
    doneSets = 0;
    angle = 0;
    stage = "up";
  }

  void doReps(var inferenceResults) {
    if (isPostureCorrect()) {
      for (var target in targets) {
        var A = target[0][0];
        var B = target[0][1];
        var C = target[0][2];
        List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
        List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
        List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
        angle = getAngle(pointA, pointB, pointC);

        print("TARGET ANGLE: " + angle.toString());
      }
      if (angle < 35) {
        stage = "down";
      }
      if (angle > 150 && stage == "down") {
        stage = "up";
        doneReps += 1;
      }
    }
  }
}

// Front lateral raise handler

class FrontLateralRaiseHandler extends ExerciseHandler {
  void init() {
    limbs = [
      [
        [5, 7, 9],
        false,
        170,
        185
      ],
      [
        [5, 11, 13],
        false,
        170,
        185
      ],
    ];
    targets = [
      [
        [7, 5, 11],
        false
      ],
    ];

    doneReps = 0;
    doneSets = 0;
    angle = 0;
    stage = "up";
  }

  void doReps(var inferenceResults) {
    if (isPostureCorrect()) {
      for (var target in targets) {
        var A = target[0][0];
        var B = target[0][1];
        var C = target[0][2];
        List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
        List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
        List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
        angle = getAngle(pointA, pointB, pointC);

        print("TARGET ANGLE: " + angle.toString());
      }
      if (angle > 80) {
        stage = "down";
      }
      if (angle < 10 && stage == "down") {
        stage = "up";
        doneReps += 1;
      }
    }
  }
}

// Shoulder press handler

class ShoulderPressHandler extends ExerciseHandler {
  var angle1 = 0.0;
  var angle2 = 0.0;
  var angle3 = 0.0;
  var angle4 = 0.0;

  List<int> pointA = [];
  List<int> pointB = [];
  List<int> pointC = [];

  void init() {
    limbs = [
      [
        [7, 5, 11],
        false,
        85,
        185
      ],
      [
        [8, 6, 12],
        false,
        85,
        185
      ],
      [
        [5, 11, 13],
        false,
        165,
        180
      ],
      [
        [6, 12, 14],
        false,
        165,
        180
      ]
    ];

    targets = [
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
    ];

    doneReps = 0;
    doneSets = 0;
    angle = 0;
    stage = "up";
  }

  void doReps(var inferenceResults) {
    if (isPostureCorrect()) {
      // for (var target in targets) {
      //   var A = target[0][0];
      //   var B = target[0][1];
      //   var C = target[0][2];
      //   List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
      //   List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
      //   List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
      //   angle = getAngle(pointA, pointB, pointC);

      //   print("TARGET ANGLE: " + angle.toString());
      // }
      // if (angle < 10) {
      //   stage = "up";
      // }
      // if (angle > 80 && stage == "up") {
      //   stage = "down";
      //   doneReps += 1;
      // }

      // right arm
      var a = 5;
      var b = 7;
      var c = 9;
      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle1 = getAngle(pointA, pointB, pointC);

      // right armpit
      a = 7;
      b = 5;
      c = 11;
      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle2 = getAngle(pointA, pointB, pointC);

      // left arm
      a = 6;
      b = 8;
      c = 10;
      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle3 = getAngle(pointA, pointB, pointC);

      // left armpit
      a = 8;
      b = 6;
      c = 12;
      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle4 = getAngle(pointA, pointB, pointC);

      print("______________________________________");
      print(angle1.toString() +
          " " +
          angle2.toString() +
          " " +
          angle3.toString() +
          " " +
          angle4.toString());

      if (angle1 > 175 && angle3 > 175) {
        stage = "down";
      }
      if (angle1 < 95 && angle3 < 95 && stage == "down") {
        stage = "up";
        doneReps += 1;
      }
    }
  }
}
