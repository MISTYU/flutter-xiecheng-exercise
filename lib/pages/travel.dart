import 'package:flutter/material.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('旅拍'),
      ),
    );
  }
}
