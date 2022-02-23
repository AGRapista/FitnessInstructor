import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'add_workout.dart';
import '../components/shared/json_handler.dart';

class SetupWorkout extends StatefulWidget {
  SetupWorkout({Key? key}) : super(key: key);

  @override
  State<SetupWorkout> createState() => _SetupWorkoutState();
}

class _SetupWorkoutState extends State<SetupWorkout> {
  late JsonHandler jsonHandler;

  // UNCOMMENT

  // late File jsonFile;
  // late Directory dir;
  // String fileName = "Workouts.json";
  // bool fileExists = false;

  // List<dynamic> fetchedWorkouts = [];
  // List<dynamic> workouts = [];

  @override
  void initState() {
    super.initState();
    initAsync();
    // UNCOMMENT

    // getApplicationDocumentsDirectory().then((Directory directory) {
    //   dir = directory;
    //   fetchWorkouts();
    // });
  }

  initAsync() async {
    jsonHandler = JsonHandler();
    await jsonHandler.init();

    setState(() {
      jsonHandler.fetchWorkouts();
      jsonHandler.weekFileExists
          ? jsonHandler.fetchWeekSchedule()
          : jsonHandler.createWeekFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    printWrapped("\n \n \nOn widget build: " + jsonHandler.workouts.toString());

    return Container(
      child: Stack(
        children: [
          jsonHandler.workouts.length != 0
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
                      itemCount: jsonHandler.workouts.length,
                      itemBuilder: (context, index) {
                        final exercise = jsonHandler.workouts[index];
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
              : Center(
                  child: Text(
                    "No workouts available",
                    textAlign: TextAlign.center,
                  ),
                ),
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
                        setState(() {
                          jsonHandler.fetchWorkouts();
                        });
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
        subtitle: buildText(workout["workout_list"]),
        trailing: IconButton(
            onPressed: () => setState(() {
                  jsonHandler.deleteWorkout(workout["workout_no"]);
                }),
            icon: Icon(Icons.delete)),
      );

  Widget buildText(List<dynamic> workouts) {
    String exerciseList = "";
    for (Map<String, dynamic> exercise in workouts) {
      exerciseList += exercise["exercise_displayName"] + ", ";
      if (exerciseList.length > 40) {
        exerciseList.substring(0, 30);
        exerciseList += "...  ";
        break;
      }
    }
    exerciseList = exerciseList.substring(0, exerciseList.length - 2);
    return Text(exerciseList);
  }

  // UNCOMMENT

  // Future<void> fetchWorkouts() async {
  //   setState(() {
  //     jsonFile = new File(dir.path + "/" + fileName);
  //     fileExists = jsonFile.existsSync();
  //     fileExists
  //         ? fetchedWorkouts = json.decode(jsonFile.readAsStringSync())
  //         : null;
  //     workouts = fetchedWorkouts;
  //   });
  // }

  // void deleteWorkout(String toDelete) {
  //   List<dynamic> newWorkouts = [];
  //   int index = 0;
  //   for (Map<String, dynamic> workout in workouts) {
  //     if (workout["workout_no"] != toDelete) {
  //       index += 1;
  //       newWorkouts.add({
  //         "workout_no": "Workout " + index.toString(),
  //         "workout_list": workout["workout_list"]
  //       });
  //     }
  //   }
  //   jsonFile.writeAsStringSync(jsonEncode(newWorkouts));
  //   setState(() {
  //     workouts = newWorkouts;
  //   });
  // }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
