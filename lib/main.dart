import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'CustomIcons.dart';
import 'todo.dart';
import 'package:flutter/foundation.dart';
import 'CustomCheckboxTile.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo'),
    );
  }
}

class ColorChoice {
  ColorChoice({@required this.primary, @required this.gradient});

  final Color primary;
  final List<Color> gradient;
}

class ColorChoices {
  static List<ColorChoice> choices = [
    ColorChoice(primary: Color(0xFFF77B67), gradient: [Color.fromRGBO(245, 68, 113, 1.0), Color.fromRGBO(245, 161, 81, 1.0)]),
    ColorChoice(primary: Color(0xFF5A89E6), gradient: [Color.fromRGBO(77, 85, 225, 1.0), Color.fromRGBO(93, 167, 231, 1.0)]),
    ColorChoice(primary: Color(0xFF4EC5AC), gradient: [Color.fromRGBO(61, 188, 156, 1.0), Color.fromRGBO(61, 212, 132, 1.0)])
  ];
}

List<TodoObject> todos = [
  // TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoies.colors[0], Icons.alarm, [TaskObject("Task", DateTime.now()),TaskObject("Task2", DateTime.now()),TaskObject.import("Task3", DateTime.now(), true)]),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ScrollController scrollController;
  Color backgroundColor;
  LinearGradient backgroundGradient;
  Tween<Color> colorTween;
  int currentPage = 0;
  Color constBackColor;

  @override
  void initState() {
    super.initState();
    colorTween = ColorTween(begin: todos[0].color, end: todos[0].color);
    backgroundColor = todos[0].color;
    backgroundGradient = todos[0].gradient;
    scrollController = ScrollController();
    scrollController.addListener(() {
      ScrollPosition position = scrollController.position;
//      ScrollDirection direction = position.userScrollDirection;
      int page = position.pixels ~/ (position.maxScrollExtent / (todos.length.toDouble() - 1));
      double pageDo = (position.pixels / (position.maxScrollExtent / (todos.length.toDouble() - 1)));
      double percent = pageDo - page;
      if (todos.length - 1 < page + 1) {
        return;
      }
      colorTween.begin = todos[page].color;
      colorTween.end = todos[page + 1].color;
      setState(() {
        backgroundColor = colorTween.transform(percent);
        backgroundGradient = todos[page].gradient.lerpTo(todos[page + 1].gradient, percent);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("TODO"),
          leading: IconButton(
            icon: Icon(CustomIcons.menu),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CustomIcons.search,
                size: 26.0,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black38, offset: Offset(5.0, 5.0), blurRadius: 15.0)],
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Text(
                "Hello, John.",
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Text(
                "This is a daily quote.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Text(
                "You have 10 tasks to do today.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 20,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  TodoObject todoObject = todos[index];
                  EdgeInsets padding = EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0);

                  double percentComplete = todoObject.percentComplete();

                  return Padding(
                      padding: padding,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => DetailPage(todoObject: todoObject), transitionDuration: Duration(milliseconds: 1000)));
                        },
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [BoxShadow(color: Colors.black.withAlpha(70), offset: Offset(3.0, 10.0), blurRadius: 15.0)]),
                            height: 250.0,
                            child: Stack(
                              children: <Widget>[
                                Hero(
                                  tag: todoObject.uuid + "_background",
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Hero(
                                                  tag: todoObject.uuid + "_backIcon",
                                                  child: Material(
                                                    type: MaterialType.transparency,
                                                    child: Container(
                                                      height: 0,
                                                      width: 0,
                                                      child: IconButton(
                                                        icon: Icon(Icons.arrow_back),
                                                        onPressed: null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Hero(
                                                  tag: todoObject.uuid + "_icon",
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(todoObject.icon, color: todoObject.color),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Hero(
                                              tag: todoObject.uuid + "_more_vert",
                                              child: Material(
                                                color: Colors.transparent,
                                                type: MaterialType.transparency,
                                                child: PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.grey,
                                                  ),
                                                  itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
                                                    PopupMenuItem(
                                                      child: Text("Edit Color"),
                                                      value: TodoCardSettings.edit_color,
                                                    ),
                                                    PopupMenuItem(
                                                      child: Text("Delete"),
                                                      value: TodoCardSettings.delete,
                                                    ),
                                                  ],
                                                  onSelected: (setting) {
                                                    switch (setting) {
                                                      case TodoCardSettings.edit_color:
                                                        print("edit color clicked");
                                                        break;
                                                      case TodoCardSettings.delete:
                                                        print("delete clicked");
                                                        setState(() {
                                                          todos.remove(todoObject);
                                                        });
                                                        break;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Hero(
                                        tag: todoObject.uuid + "_number_of_tasks",
                                        child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              todoObject.taskAmount().toString() + " Tasks",
                                              style: TextStyle(),
                                              softWrap: false,
                                            )),
                                      ),
                                      Spacer(),
                                      Hero(
                                        tag: todoObject.uuid + "_title",
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            todoObject.title,
                                            style: TextStyle(fontSize: 30.0),
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Hero(
                                        tag: todoObject.uuid + "_progress_bar",
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  value: percentComplete,
                                                  backgroundColor: Colors.grey.withAlpha(50),
                                                  valueColor: AlwaysStoppedAnimation<Color>(todoObject.color),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 5.0),
                                                child: Text((percentComplete * 100).round().toString() + "%"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ));
                },
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                scrollDirection: Axis.horizontal,
                physics: CustomScrollPhysics(),
                controller: scrollController,
                itemExtent: _width - 80,
                itemCount: todos.length,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

enum TodoCardSettings { edit_color, delete }

class DetailPage extends StatefulWidget {
  DetailPage({@required this.todoObject, Key key}) : super(key: key);

  final TodoObject todoObject;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;

  @override
  void initState() {
    scaleAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar = AnimationController(vsync: this, duration: Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {
          barPercent = animT.transform(animationBar.value);
        });
      });
    animT = Tween<double>(begin: percentComplete, end: percentComplete);
    scaleAnimation.forward();
    super.initState();
  }

  void updateBarPercent() async {
    double newPercentComplete = widget.todoObject.percentComplete();
    if (animationBar.status == AnimationStatus.forward || animationBar.status == AnimationStatus.completed) {
      animT.begin = newPercentComplete;
      await animationBar.reverse();
    } else {
      animT.end = newPercentComplete;
      await animationBar.forward();
    }
    percentComplete = newPercentComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: widget.todoObject.uuid + "_background",
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Hero(
              tag: widget.todoObject.uuid + "_backIcon",
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            actions: <Widget>[
              Hero(
                tag: widget.todoObject.uuid + "_more_vert",
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
                      PopupMenuItem(
                        child: Text("Edit Color"),
                        value: TodoCardSettings.edit_color,
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: TodoCardSettings.delete,
                      ),
                    ],
                    onSelected: (setting) {
                      switch (setting) {
                        case TodoCardSettings.edit_color:
                          print("edit color clicked");
                          break;
                        case TodoCardSettings.delete:
                          print("delete clicked");
                          break;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            widget.todoObject.icon,
                            color: widget.todoObject.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_number_of_tasks",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.todoObject.taskAmount().toString() + " Tasks",
                          style: TextStyle(),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_title",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.todoObject.title,
                          style: TextStyle(fontSize: 30.0),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_progress_bar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(widget.todoObject.color),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text((barPercent * 100).round().toString() + "%"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.todoObject.uuid + "_just_a_test",
                    child: Material(
                      type: MaterialType.transparency,
                      child: FadeTransition(
                        opacity: scaleAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0.0),
                            itemBuilder: (BuildContext context, int index) {
                              DateTime currentDate = widget.todoObject.tasks.keys.toList()[index];
                              DateTime _now = DateTime.now();
                              DateTime today = DateTime(_now.year, _now.month, _now.day);
                              String dateString;
                              if (currentDate.isBefore(today.subtract(Duration(days: 7)))) {
                                dateString = DateFormat.yMMMMEEEEd().format(currentDate);
                              } else if (currentDate.isBefore(today)) {
                                dateString = "Previous - " + DateFormat.E().format(currentDate);
                              } else if (currentDate.isAtSameMomentAs(today)) {
                                dateString = "Today";
                              } else if (currentDate.isAtSameMomentAs(today.add(Duration(days: 1)))) {
                                dateString = "Tomorrow";
                              } else {
                                dateString = DateFormat.E().format(currentDate);
                              }
                              List<Widget> tasks = [Text(dateString)];
                              widget.todoObject.tasks[currentDate].forEach((task) {
                                tasks.add(CustomCheckboxListTile(
                                  activeColor: widget.todoObject.color,
                                  value: task.isCompleted(),
                                  onChanged: (value) {
                                    setState(() {
                                      task.setComplete(value);
                                      updateBarPercent();
                                    });
                                  },
                                  title: Text(task.task),
                                  secondary: Icon(Icons.alarm),
                                ));
                              });
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tasks,
                              );
                            },
                            itemCount: widget.todoObject.tasks.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  CustomScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position) {
    return position.pixels / (position.maxScrollExtent / (todos.length.toDouble() - 1));
    // return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollPosition position, double page) {
    // return page * position.viewportDimension;
    return page * (position.maxScrollExtent / (todos.length.toDouble() - 1));
  }

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity) page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) || (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }
}
