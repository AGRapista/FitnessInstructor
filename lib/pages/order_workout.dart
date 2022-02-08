import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    selected_cardsNo = selected_cards.length;
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
    ;
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              OrderWorkout(selected_cards: selected_cards),
          transitionDuration: Duration(seconds: 0),
          reverseTransitionDuration: Duration.zero),
    );
  }
}
