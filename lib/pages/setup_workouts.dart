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
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Your workouts",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final exercise = workouts[index];
                        printWrapped("On build item: " + exercise.toString());
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: buildItem(index, exercise),
                        );
                      },
                    ),
                  ]),
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
        title: Text(workout["workout_no"],
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20)),
        subtitle: Row(children: [
          for (Map<String, dynamic> exercise in workout["workout_list"])
            Text(exercise["exercise_displayName"] + " ")
        ]),
        trailing: IconButton(onPressed: null, icon: Icon(Icons.delete)),
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
