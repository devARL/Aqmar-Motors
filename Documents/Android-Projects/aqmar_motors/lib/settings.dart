import 'package:flutter/material.dart';


class settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Setts();
    }
}

class Setts extends StatefulWidget {

  @override
  SettState createState() => new SettState();
}

class SettState extends State<Setts> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text('Settings'),
    centerTitle: true,
    backgroundColor: Colors.red,
    ),

    );
  }
  }