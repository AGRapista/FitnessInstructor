import 'package:flutter/material.dart';
import '../../pages/manage_workout.dart';

class setup_button extends StatefulWidget {
  setup_button({Key? key}) : super(key: key);

  @override
  State<setup_button> createState() => _setup_buttonState();
}

class _setup_buttonState extends State<setup_button> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ManageWorkout(),
                transitionDuration: Duration(seconds: 0),
                reverseTransitionDuration: Duration.zero),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    child: Container(
                      height: 150,
                      width: 300,
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            width: 250,
                            child: Center(
                              child: Text(
                                "MANAGE\nWORKOUTS",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(100)),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
                Positioned(
                  right: 30,
                  top: 40,
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Image.asset(
                        'assets/img/setup_icon.png',
                        height: 36,
                        width: 36,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
