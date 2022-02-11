import 'package:flutter/material.dart';
import 'package:project/pages/setup_routine.dart';
import 'setup_workouts.dart';

class ManageWorkout extends StatefulWidget {
  ManageWorkout({Key? key}) : super(key: key);

  @override
  State<ManageWorkout> createState() => _ManageWorkoutState();
}

class _ManageWorkoutState extends State<ManageWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
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
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: 'Workouts',
                      ),
                      Tab(
                        text: 'Routine',
                      )
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              children: [SetupWorkout(), SetupRoutine()],
            )),
      ),
    );
  }
}
