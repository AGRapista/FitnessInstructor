import 'package:flutter/material.dart';
import '../../test.dart';
import '../shared/json_handler.dart';

class continue_button extends StatefulWidget {
  continue_button({Key? key}) : super(key: key);

  @override
  State<continue_button> createState() => _continue_buttonState();
}

class _continue_buttonState extends State<continue_button> {
  late JsonHandler jsonHandler;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    jsonHandler = JsonHandler();
    await jsonHandler.init();
    setState(() {
      jsonHandler.weekFileExists ? jsonHandler.fetchWeekSchedule() : null;
      jsonHandler.fetchDayToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Test(),
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
                                "CONTINUE\nWORKOUT",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
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
                    child: Center(
                      child: Image.asset(
                        'assets/img/continue_icon.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    height: 60,
                    width: 60,
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
