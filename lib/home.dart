import 'package:flutter/material.dart';
import 'components/appbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          title: MainAppBar(),
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 200,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200))),
        )
      ]),
    );
  }
}
