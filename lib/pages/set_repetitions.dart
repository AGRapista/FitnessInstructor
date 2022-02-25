import 'package:flutter/material.dart';
import 'package:project/pages/add_workout.dart';

import '../components/shared/exerciseItem.dart';
import '../components/shared/exerciseList.dart';

import 'order_workout.dart';

class SetRepetitions extends StatefulWidget {
  List<Exercise> selected_cards;
  SetRepetitions({Key? key, required this.selected_cards}) : super(key: key);

  @override
  State<SetRepetitions> createState() => _SetRepetitionsState(selected_cards);
}

class _SetRepetitionsState extends State<SetRepetitions> {
  List<Exercise> selected_cards;

  void onSliderChange(int RepsOrSets, double value, Exercise exercise) {
    final indexOfExercise = selected_cards.indexOf(exercise);
    setState(() {
      RepsOrSets == 0
          ? selected_cards[indexOfExercise].reps = value.round()
          : selected_cards[indexOfExercise].sets = value.round();
    });
  }

  _SetRepetitionsState(this.selected_cards);

  @override
  void initState() {
    super.initState();
    // Resetting rep and set counters
    for (Exercise exercise in selected_cards) {
      exercise.reps = 1;
      exercise.sets = 1;
    }
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
        height: 1000,
        child: Stack(children: [
          ClipRect(
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(" Set exercise sets and repetitions",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),
                  Container(
                    child: ClipRect(
                        child: Column(
                      children: [
                        for (Exercise exercise in selected_cards)
                          Container(
                              child: Row(
                            children: [
                              Center(
                                  child: Image.asset(exercise.exercise_image,
                                      height: 200, width: 150)),
                              SliderTheme(
                                data: SliderThemeData(trackHeight: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(children: [
                                          Text('Reps'),
                                          Text(exercise.reps.toInt().toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 30)),
                                        ]),
                                        SizedBox(
                                          width: 140,
                                          child: Slider(
                                              value: exercise.reps.toDouble(),
                                              min: 1,
                                              max: 30,
                                              onChanged: (value) =>
                                                  onSliderChange(
                                                      0, value, exercise)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(children: [
                                          Text('Sets'),
                                          Text(exercise.sets.toInt().toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 30)),
                                        ]),
                                        SizedBox(
                                          width: 140,
                                          child: Slider(
                                              value: exercise.sets.toDouble(),
                                              min: 1,
                                              max: 30,
                                              onChanged: (value) =>
                                                  onSliderChange(
                                                      1, value, exercise)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ))
                      ],
                    )),
                  ),
                ]),
          ),
          Positioned(
              bottom: 20,
              right: 10,
              child: FloatingActionButton(
                  onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                OrderWorkout(selected_cards: selected_cards),
                            transitionDuration: Duration(seconds: 0),
                            reverseTransitionDuration: Duration.zero),
                      ).then((value) {
                        setState(() {});
                      }),
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
}
