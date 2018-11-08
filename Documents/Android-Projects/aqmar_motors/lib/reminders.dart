import 'package:flutter/material.dart';


class reminders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Rmndrs();
  }
}

class Rmndrs extends StatefulWidget {
  @override
  RmndrState createState() => new RmndrState();
}

class RmndrState extends State<Rmndrs> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reminders'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

    );
  }
}