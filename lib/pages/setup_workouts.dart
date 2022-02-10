import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'add_workout.dart';
import '../components/workout_components/workoutList.dart';

class SetupWorkout extends StatefulWidget {
  SetupWorkout({Key? key}) : super(key: key);

  @override
  State<SetupWorkout> createState() => _SetupWorkoutState();
}

class _SetupWorkoutState extends State<SetupWorkout> {
  late File jsonFile;
  late Directory dir;
  String fileName = "Workouts.json";
  bool fileExists = false;

  List<dynamic> fetchedWorkouts = [];
  List<dynamic> workouts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    printWrapped("\n \n \nOn widget build: " + workouts.toString());

    return Container(
      child: Stack(
        children: [
          fileExists
              ? Container(
                  child: ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final exercise = workouts[index];
                      printWrapped("On build item: " + exercise.toString());
                      return buildItem(index, exercise);
                    },
                  ),
                )
              : Positioned(
                  top: 50, left: 50, child: Text("No workouts available")),
          Positioned(
              bottom: 20,
              right: 10,
              child: FloatingActionButton(
                  onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                AddWorkout(),
                            transitionDuration: Duration(seconds: 0),
                            reverseTransitionDuration: Duration.zero),
                      ).then((value) {
                        fetchWorkouts();
                      }),
                  backgroundColor: Colors.black,
                  child: Center(
                      child: Image.asset(
                    'assets/img/add_icon.png',
                    height: 20,
                    width: 20,
                  ))))
        ],
      ),
    );
  }

  Widget buildItem(int index, Map<String, dynamic> workout) => ListTile(
        key: ValueKey(workout),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Text(workout["workout_no"]),
      );

  Future<void> fetchWorkouts() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      setState(() {
        jsonFile = new File(dir.path + "/" + fileName);
        fileExists = jsonFile.existsSync();
        fileExists
            ? fetchedWorkouts = json.decode(jsonFile.readAsStringSync())
            : null;
        printWrapped(
            fileExists.toString() + " asdasd " + fetchedWorkouts.toString());
        workouts = fetchedWorkouts;
      });
    });
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
