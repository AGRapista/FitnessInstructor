// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import '../components/shared/json_handler.dart';

class SetupRoutine extends StatefulWidget {
  SetupRoutine({Key? key}) : super(key: key);

  @override
  State<SetupRoutine> createState() => _SetupRoutineState();
}

class _SetupRoutineState extends State<SetupRoutine> {
  late JsonHandler jsonHandler;

  // UNCOMMENT

  // late File workoutJsonFile;
  // late File weekJsonFile;

  // late Directory dir;

  // String workoutsFileName = "Workouts.json";
  // String weekFileName = "WeekSchedule.json";
  // bool workoutfileExists = false;
  // bool weekFileExists = false;

  // List<dynamic> workouts = [];
  // Map<String, dynamic> weekSchedule = {};

  String selectedWorkout = "Workout 1";

  @override
  void initState() {
    super.initState();

    // UNCOMMENT

    // getApplicationDocumentsDirectory().then((Directory directory) {
    //   dir = directory;
    //   weekJsonFile = File(dir.path + "/" + weekFileName);
    //   weekFileExists = weekJsonFile.existsSync();
    //   fetchWorkouts();
    //   print("WEEK EXISTS: " + weekFileExists.toString());
    //   weekFileExists ? fetchWeekSchedule() : createWeekFile();
    //   print("WEEK SCHED: " + weekSchedule.toString());
    // });

    initAsync();
  }

  initAsync() async {
    jsonHandler = JsonHandler();
    await jsonHandler.init();
    jsonHandler.fetchWorkouts();
    setState(() {
      jsonHandler.weekFileExists
          ? jsonHandler.fetchWeekSchedule()
          : jsonHandler.createWeekFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: jsonHandler.workouts.length > 0
          ? Container(
              child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Routine",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    alignment: Alignment.centerLeft,
                    child: Text("Select workout:")),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 4)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                        value: selectedWorkout,
                        items: jsonHandler.workouts.map(buildMenuItem).toList(),
                        onChanged: (workout) => setState(() {
                              selectedWorkout = workout;
                            })),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    alignment: Alignment.centerLeft,
                    child: Text("Select days:")),
                SizedBox(
                  height: 30,
                ),
                buildWeekRow()
              ],
            ))
          : Center(
              child: Text(
                "No workouts available, please create one first",
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  DropdownMenuItem buildMenuItem(workout) => DropdownMenuItem(
      value: workout["workout_no"], child: Text(workout["workout_no"]));

  Row buildWeekRow() => Row(
        children: [
          SizedBox(width: 5),
          for (String day in [
            "Sun",
            "Mon",
            "Tues",
            "Wed",
            "Thurs",
            "Fri",
            "Sat"
          ])
            Column(
              children: [
                Center(child: Text(day)),
                InkWell(
                  onTap: jsonHandler.weekSchedule[day] == selectedWorkout
                      ? () => setState(() {
                            jsonHandler.writeToWeekFile("", day);
                          })
                      : () => setState(() {
                            jsonHandler.writeToWeekFile(selectedWorkout, day);
                          }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: jsonHandler.weekSchedule[day] == selectedWorkout
                        ? Colors.green
                        : jsonHandler.weekSchedule[day] == ""
                            ? Colors.grey
                            : Colors.red,
                    height: 40,
                    width: 40,
                  ),
                )
              ],
            ),
        ],
      );

  // UNCOMMENT

  // Future<void> fetchWorkouts() async {
  //   setState(() {
  //     workoutJsonFile = File(dir.path + "/" + workoutsFileName);
  //     workoutfileExists = workoutJsonFile.existsSync();
  //     workoutfileExists
  //         ? workouts = json.decode(workoutJsonFile.readAsStringSync())
  //         : null;
  //   });
  // }

  // Future<void> fetchWeekSchedule() async {
  //   setState(() {
  //     weekJsonFile = File(dir.path + "/" + weekFileName);
  //     weekSchedule = json.decode(weekJsonFile.readAsStringSync());
  //   });
  //   // weekJsonFile.delete();
  //   // print("EXISTS? " + weekJsonFile.existsSync().toString());
  // }

  // void createWeekFile() {
  //   print("\n \n Creating file");

  //   Map<String, String> emptyWeek = {
  //     "Sun": "",
  //     "Mon": "",
  //     "Tues": "",
  //     "Wed": "",
  //     "Thurs": "",
  //     "Fri": "",
  //     "Sat": ""
  //   };

  //   weekJsonFile.createSync();
  //   weekFileExists = true;
  //   weekJsonFile.writeAsStringSync(json.encode(emptyWeek));

  //   fetchWeekSchedule();
  // }

  // void writeToWeekFile(String workout_no, String day) {
  //   setState(() {
  //     weekSchedule[day] = workout_no;
  //   });
  //   weekJsonFile.writeAsStringSync(json.encode(weekSchedule));
  // }
}
