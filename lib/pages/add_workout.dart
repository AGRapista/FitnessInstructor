import 'package:flutter/material.dart';

class AddWorkout extends StatefulWidget {
  AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  late double card_height;
  late double card_width;

  bool card1_selected = false;
  bool card2_selected = false;
  bool card3_selected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      card_height = 200;
      card_width = 150;
    });
    print("\n hey\n" + card_height.toString());
  }

  void onSelect(int card) {
    setState(() {
      switch (card) {
        case 1:
          card1_selected = !card1_selected;
          break;
        case 2:
          card2_selected = !card2_selected;
          break;
        case 3:
          card3_selected = !card3_selected;
          break;
      }
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
                left: 90,
                child: Text(
                  'Select workouts',
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
                          onTap: () => onSelect(1),
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
                        decoration: card1_selected
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
                          onTap: () => onSelect(2),
                          child: Center(
                            child: Image.asset(
                                'assets/img/card_lateralraise.png',
                                height: card_height,
                                width: card_width),
                          ),
                        ),
                        decoration: card2_selected
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
                          onTap: () => onSelect(3),
                          child: Center(
                            child: Image.asset(
                                'assets/img/card_shoulderpress.png',
                                height: card_height,
                                width: card_width),
                          ),
                        ),
                        decoration: card3_selected
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
      ),
    );
  }
}
