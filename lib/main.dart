import 'package:flutter/material.dart';
import 'package:todo/pages/Home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODO',
      home: HomePage(),
    );
  }
}
