import 'package:flutter/material.dart';
import 'package:project/components/shared/exerciseItem.dart';
import 'set_repetitions.dart';
import '../components/shared/exerciseItem.dart';
import '../components/shared/exerciseList.dart';

class AddWorkout extends StatefulWidget {
  AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  late double card_height;
  late double card_width;

// Inefficient/ugly way of doing this, but for 3 selectable exercises, it would do
// TODO (potentially): Change into dynamic exeercise selection

  List<Exercise> includedExercises = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      card_height = 200;
      card_width = 150;
    });
    print("\n hey\n" + card_height.toString());
  }

  void onSelect(Exercise? exercise) {
    setState(() {
      if (includedExercises.contains(exercise)) {
        includedExercises.remove(exercise!);
        return;
      }
      includedExercises.add(exercise!);
    });
  }

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
        child: Stack(
          children: [
            Positioned(
                top: 50,
                left: 40,
                child: Text(
                  'Select exercises to include\n         in your workout',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25),
                )),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () => onSelect(Exercises["dumbell_curl"]),
                          child: Container(
                            child: Center(
                              child: Image.asset(
                                'assets/img/card_dumbellcurl.png',
                                height: card_height,
                                width: card_width,
                              ),
                            ),
                          ),
                        ),
                        decoration: includedExercises
                                .contains(Exercises["dumbell_curl"])
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 6.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(
                                        0.0,
                                        3.0,
                                      ),
                                    ),
                                  ])
                            : null,
                      ),
                      Container(
                        child: InkWell(
                          onTap: () => onSelect(Exercises["lateral_raise"]),
                          child: Center(
                            child: Image.asset(
                                'assets/img/card_lateralraise.png',
                                height: card_height,
                                width: card_width),
                          ),
                        ),
                        decoration: includedExercises
                                .contains(Exercises["lateral_raise"])
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 6.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(
                                        0.0,
                                        3.0,
                                      ),
                                    ),
                                  ])
                            : null,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () => onSelect(Exercises["shoulder_press"]),
                          child: Center(
                            child: Image.asset(
                                'assets/img/card_shoulderpress.png',
                                height: card_height,
                                width: card_width),
                          ),
                        ),
                        decoration: includedExercises
                                .contains(Exercises["shoulder_press"])
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 6.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(
                                        0.0,
                                        3.0,
                                      ),
                                    ),
                                  ])
                            : null,
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 20,
                right: 10,
                child: FloatingActionButton(
                    onPressed: includedExercises.length != 0
                        ? () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation1,
                                          animation2) =>
                                      SetRepetitions(
                                          selected_cards: includedExercises),
                                  transitionDuration: Duration(seconds: 0),
                                  reverseTransitionDuration: Duration.zero),
                            )
                        : null,
                    backgroundColor: Colors.black,
                    child: Center(
                        child: Image.asset(
                      'assets/img/add_icon.png',
                      height: 20,
                      width: 20,
                    ))))
          ],
        ),
      ),
    );
  }
}
