import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../components/home_components/continue_button.dart';
import '../components/home_components/manage_button.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          title: MainAppBar(),
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 200,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100))),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
                <Widget>[continue_button(), setup_button()]))
      ]),
    );
  }
}
