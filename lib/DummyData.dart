import 'package:todo/objects/ColorChoice.dart';
import 'package:todo/objects/TodoObject.dart';
import 'package:flutter/material.dart';

List<TodoObject> todos = [
  TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoices.choices[0], Icons.alarm, {
    DateTime(2018, 5, 3): [
      TaskObject("Meet Clients", DateTime(2018, 5, 3)),
      TaskObject("Design Sprint", DateTime(2018, 5, 3)),
      TaskObject("Icon Set Design for Mobile", DateTime(2018, 5, 3)),
      TaskObject("HTML/CSS Study", DateTime(2018, 5, 3)),
    ],
    DateTime(2019, 5, 4): [
      TaskObject("Meet Clients", DateTime(2019, 5, 4)),
      TaskObject("Design Sprint", DateTime(2019, 5, 4)),
      TaskObject("Icon Set Design for Mobile", DateTime(2019, 5, 4)),
      TaskObject("HTML/CSS Study", DateTime(2019, 5, 4)),
    ]
  }),
  TodoObject("Personal", Icons.person),
  TodoObject("Work", Icons.work),
  TodoObject("Home", Icons.home),
  TodoObject("Shopping", Icons.shopping_basket),
  TodoObject("School", Icons.school),
];
