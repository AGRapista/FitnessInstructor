import 'package:flutter/material.dart';
import '../components/appbar.dart';

class SetupWorkout extends StatefulWidget {
  SetupWorkout({Key? key}) : super(key: key);

  @override
  State<SetupWorkout> createState() => _SetupWorkoutState();
}

class _SetupWorkoutState extends State<SetupWorkout> {
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
            body: Container()),
      ),
    );
  }
}
