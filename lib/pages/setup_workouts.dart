import 'package:flutter/material.dart';
import 'add_workout.dart';

class SetupWorkout extends StatefulWidget {
  SetupWorkout({Key? key}) : super(key: key);

  @override
  State<SetupWorkout> createState() => _SetupWorkoutState();
}

class _SetupWorkoutState extends State<SetupWorkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(),
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
                      ),
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
}
