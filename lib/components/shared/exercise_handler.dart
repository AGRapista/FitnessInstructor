import 'dart:ffi';
import '../perform_components/utility.dart';

abstract class ExerciseHandler {
  bool isPostureCorrect();
  void init();
  void checkLimbs(var inferenceResults, var limbsIndex);
  void doReps(var inferenceResults);
}

// Dumbell Curl Handler
class DumbellCurlHandler extends ExerciseHandler {
  late List<dynamic> limbs;
  late List<dynamic> targets;

  late bool isProperForm;
  late int doneReps;
  late int doneSets;
  late var stage;
  late var angle;

  void init() {
    print("HELLO");
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
    stage = "up";
  }

  @override
  bool isPostureCorrect() {
    for (var limb in limbs) {
      if (limb[1] == false) {
        return false;
      }
    }
    return true;
  }

  @override
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

  @override
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
