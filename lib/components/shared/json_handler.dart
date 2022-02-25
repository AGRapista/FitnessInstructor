import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'exerciseItem.dart';

class JsonHandler {
  late Directory dir;

  late File workoutJsonFile;
  late File weekJsonFile;

  late String workoutsFileName;
  late String weekFileName;

  late bool workoutfileExists;
  late bool weekFileExists;

  late var dayToday;

  List<dynamic> workouts = [];
  Map<String, dynamic> weekSchedule = {};

  Future<void> init() async {
    print("\n \n \nInitializing...");

    dir = await getApplicationDocumentsDirectory();

    // getApplicationDocumentsDirectory().then((Directory directory) {
    //   dir = directory;

    //   print("\n \n \nFinished");
    // });

    print("\n \n \nPATH: " + dir.path + "/");

    workoutJsonFile = File(dir.path + "/" + "Workouts.json");
    weekJsonFile = File(dir.path + "/" + "WeekSchedule.json");

    workoutsFileName = "Workouts.json";
    weekFileName = "WeekSchedule.json";

    workoutfileExists = workoutJsonFile.existsSync();
    weekFileExists = weekJsonFile.existsSync();

    print("FINISHED ");
  }

  Future<void> fetchWorkouts() async {
    print("\n \n \nFetching workouts: ");
    workoutfileExists = workoutJsonFile.existsSync();
    workoutfileExists
        ? workouts = json.decode(workoutJsonFile.readAsStringSync())
        : null;
  }

  Future<void> fetchWeekSchedule() async {
    print("\n \n \nFetching routine: ");
    weekSchedule = json.decode(weekJsonFile.readAsStringSync());
    // weekJsonFile.delete();
    // print("EXISTS? " + weekJsonFile.existsSync().toString());
  }

  void createWorkoutFile() {
    print("\n \n \nCreating workout file");
    workoutJsonFile.createSync();
    workoutfileExists = true;
    workoutJsonFile.writeAsStringSync("[]");
  }

  void writeToWorkoutFile(List<Exercise> exerciseSelection) {
    List<dynamic> content = json.decode(workoutJsonFile.readAsStringSync());
    List<dynamic> exercises = [];
    for (Exercise exercise in exerciseSelection) {
      exercises.add({
        "exercise_name": exercise.exercise_name,
        "exercise_image": exercise.exercise_image,
        "exercise_displayName": exercise.exercise_displayName,
        "reps": exercise.reps,
        "sets": exercise.sets
      });
    }
    content.add({
      'workout_no': "Workout " + (content.length + 1).toString(),
      'workout_list': exercises
    });
    workoutJsonFile.writeAsStringSync(jsonEncode(content));
    print("\n-------------- CONTENT ----------------\n" + content.toString());
    // jsonFile.delete();
  }

  void createWeekFile() {
    print("\n \n Creating week file");

    Map<String, String> emptyWeek = {
      "Sun": "",
      "Mon": "",
      "Tues": "",
      "Wed": "",
      "Thurs": "",
      "Fri": "",
      "Sat": ""
    };

    weekJsonFile.createSync();
    weekFileExists = true;
    weekJsonFile.writeAsStringSync(json.encode(emptyWeek));

    fetchWeekSchedule();
  }

  void writeToWeekFile(String workout_no, String day) {
    weekSchedule[day] = workout_no;
    weekJsonFile.writeAsStringSync(json.encode(weekSchedule));
  }

  void deleteWorkout(String toDelete) {
    List<dynamic> newWorkouts = [];
    int index = 0;
    for (Map<String, dynamic> workout in workouts) {
      if (workout["workout_no"] != toDelete) {
        index += 1;
        newWorkouts.add({
          "workout_no": "Workout " + index.toString(),
          "workout_list": workout["workout_list"]
        });
      }
    }
    workoutJsonFile.writeAsStringSync(jsonEncode(newWorkouts));
    workouts = newWorkouts;

    int indexOfDeleted = int.parse(toDelete.substring(toDelete.length - 1));

    for (var day in weekSchedule.keys) {
      // print(day + " | " + weekSchedule[day]);
      weekSchedule[day] == toDelete ? writeToWeekFile("", day) : null;
    }

    for (var day in weekSchedule.keys) {
      // print(day + " | " + weekSchedule[day]);
      weekSchedule[day] != ""
          ? int.parse(weekSchedule[day].substring(toDelete.length - 1)) >
                  indexOfDeleted
              ? writeToWeekFile(
                  weekSchedule[day].substring(0, 8) + indexOfDeleted.toString(),
                  day)
              : null
          : null;
    }
    // weekJsonFile.delete();

    // printWrapped(json.decode(weekJsonFile.readAsStringSync()));
  }

  String fetchDayToday() {
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
    return dayToday;
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
