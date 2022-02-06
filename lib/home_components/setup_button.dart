import 'package:flutter/material.dart';

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
          onTap: null,
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
                                "SETUP\nWORKOUTS",
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
                        height: 40,
                        width: 40,
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
