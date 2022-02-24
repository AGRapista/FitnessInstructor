import 'exerciseItem.dart';
import 'exercise_handler.dart';

Map<String, Exercise> Exercises = {
  "dumbell_curl": Exercise(
      exercise_image: 'assets/img/card_dumbellcurl.png',
      exercise_name: "dumbell_curl",
      exercise_displayName: "Dumbell curl",
      reps: 1,
      sets: 1,
      handler: DumbellCurlHandler()),
  "lateral_raise": Exercise(
      exercise_image: 'assets/img/card_lateralraise.png',
      exercise_name: "lateral_raise",
      exercise_displayName: "Front lateral raise",
      reps: 1,
      sets: 1,
      handler: FrontLateralRaiseHandler()),
  "shoulder_press": Exercise(
      exercise_image: 'assets/img/card_shoulderpress.png',
      exercise_name: "shoulder_press",
      exercise_displayName: "Shoulder press",
      reps: 1,
      sets: 1,
      handler: ShoulderPressHandler()),
};
