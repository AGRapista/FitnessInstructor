class Exercise {
  String exercise_name;
  String exercise_displayName;
  String exercise_image;
  int reps;
  int sets;
  Object handler;

  Exercise(
      {required this.exercise_name,
      required this.exercise_displayName,
      required this.exercise_image,
      required this.reps,
      required this.sets,
      required this.handler});
}
