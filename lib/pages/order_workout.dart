import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../components/workout_components/exerciseItem.dart';
import '../components/workout_components/exerciseList.dart';

class OrderWorkout extends StatefulWidget {
  List<Exercise> selected_cards;

  OrderWorkout({Key? key, required this.selected_cards}) : super(key: key);

  @override
  State<OrderWorkout> createState() => _OrderWorkoutState(selected_cards);
}

class _OrderWorkoutState extends State<OrderWorkout> {
  List<Exercise> selected_cards;
  late int selected_cardsNo;

  late File jsonFile;
  late Directory dir;
  String fileName = "Workouts.json";
  bool fileExists = false;

  @override
  void initState() {
    super.initState();
    selected_cardsNo = selected_cards.length;
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      fileExists
          ? print("File exists!")
          // setState(
          //     () => fileContent = jsonDecode(jsonFile.readAsStringSync()))
          : createFile();
    });
  }

  _OrderWorkoutState(this.selected_cards);

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
                child: Text('Manage workouts')),
            Image.asset('assets/img/shoulder_press_icon.png',
                width: 35, height: 35)
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Hold and drag items into\n   the desired sequence",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),
              Flexible(
                child: ReorderableListView.builder(
                  itemCount: selected_cardsNo,
                  itemBuilder: (context, index) {
                    final exercise = selected_cards[index];
                    return buildItem(index, exercise);
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                    final exercise = selected_cards.removeAt(oldIndex);
                    selected_cards.insert(index, exercise);
                  },
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 20,
              right: 10,
              child: FloatingActionButton(
                  onPressed: () => SaveWorkouts(),
                  backgroundColor: Colors.black,
                  child: Center(
                      child: Image.asset(
                    'assets/img/add_icon.png',
                    height: 20,
                    width: 20,
                  ))))
        ]),
      ),
    );
  }

  Widget buildItem(int index, Exercise exercise) => ListTile(
        key: ValueKey(exercise),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Image.asset(exercise.exercise_image),
        title: Text(
          exercise.exercise_displayName,
          style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
        ),
        trailing: Text(
            ' Reps: ' +
                exercise.reps.toString() +
                ' Sets: ' +
                exercise.sets.toString(),
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
      );
  void SaveWorkouts() {
    writeToFile(selected_cards);
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 3;
    });

    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //       pageBuilder: (context, animation1, animation2) =>
    //           OrderWorkout(selected_cards: selected_cards),
    //       transitionDuration: Duration(seconds: 0),
    //       reverseTransitionDuration: Duration.zero),
    // );
  }

  void createFile() {
    print("\n \n Creating file");
    File file = new File(dir.path + "/" + fileName);
    jsonFile.createSync();
    fileExists = true;
    jsonFile.writeAsStringSync("[]");
  }

  void writeToFile(List<Exercise> exerciseSelection) {
    List<dynamic> content = json.decode(jsonFile.readAsStringSync());
    Map<String, dynamic> exercises = {};
    for (Exercise exercise in exerciseSelection) {
      exercises.addAll({
        exercise.exercise_name: {
          "exercise_image": exercise.exercise_image,
          "exercise_name": exercise.exercise_name,
          "exercise_displayName": exercise.exercise_displayName,
          "reps": exercise.reps,
          "sets": exercise.sets
        }
      });
    }
    content.add({
      'workout_no': "Workout " + content.length.toString(),
      'workout_list': exercises
    });
    jsonFile.writeAsStringSync(jsonEncode(content));
    print("\n-------------- CONTENT ----------------\n" + content.toString());
    // jsonFile.delete();
  }
}
