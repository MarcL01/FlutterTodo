import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/DummyData.dart';
import 'package:todo/CustomIcons.dart';
import 'package:todo/objects/TodoObject.dart';
import 'package:todo/pages/Details.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
  void dispose() {
    super.dispose();
    scrollController.dispose();
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
          centerTitle: true,
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
            Padding(
              padding: EdgeInsets.only(
                left: 50.0,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "TODAY : ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 20,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  TodoObject todoObject = todos[index];
                  double percentComplete = todoObject.percentComplete();

                  return Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => DetailPage(todoObject: todoObject),
                            transitionDuration: Duration(milliseconds: 1000),
                          ),
                        );
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
                        ),
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                scrollDirection: Axis.horizontal,
                physics: _CustomScrollPhysics(),
                controller: scrollController,
                itemExtent: _width - 80,
                itemCount: todos.length,
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomScrollPhysics extends ScrollPhysics {
  _CustomScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  _CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _CustomScrollPhysics(parent: buildParent(ancestor));
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
