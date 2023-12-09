// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinora/constants.dart';
import 'package:tinora/model/tasks_model.dart';
import 'package:tinora/pages/landing_pages.dart';
import 'package:tinora/pages/task_action.dart';
import 'package:tinora/provider/tasks_provider.dart';

class HomePages extends StatefulWidget {
  final TasksModel? tasks;
  const HomePages({Key? key, this.tasks}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());
  String dayName = DateFormat('EEEE, MMMM yyyy').format(DateTime.now());
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  int navIx = 0;
  late Timer _timer;
  List<TasksModel> _task = [];
  List<Color> usedColor = [
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.blue.shade200,
    Colors.deepOrange.shade200
  ];

  @override
  void initState() {
    super.initState();
    _getTasks();

    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  // ignore: unused_element
  Future<bool> _checkAuth() async {
    final prefs = await _prefs;
    if (!prefs.containsKey('user')) {
      return false;
    }
    return true;
  }

  void _update() {
    setState(() {
      formattedDate = DateFormat('kk:mm').format(DateTime.now());
    });
  }

  _getTasks() async {
    TasksProvider.getAllTasks().then((value) => setState(() {
          _task = value!;
        }));
  }

  _logOut() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        index: navIx,
        height: 55,
        backgroundColor: Colors.transparent,
        color: Colors.deepPurple.shade200,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Icon(
            Icons.exit_to_app_outlined,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _showTaskActionDialog();
            setState(() {
              navIx = 0;
            });
            print(navIx);
          }
          if (index == 2) {
            _logOut();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LandingPages()));
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
              left: 15,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      dayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 24,
                    // crossAxisSpacing: 8,
                    children: [
                      for (var i in _task)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Material(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              focusColor: Colors.red,
                              highlightColor: Colors.greenAccent,
                              splashColor: Colors.yellowAccent,
                              hoverColor: Colors.blueAccent,
                              onLongPress: () =>
                                  _showTaskActionDialog(tasks: i),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: usedColor[
                                      _task.indexOf(i) % usedColor.length],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 18,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('dd-MM-yyyy')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        i.toMap()['deadline']))
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.deepPurple,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: i.toMap()['isImportant'] == 1
                                                ? Icon(
                                                    Icons.star_rounded,
                                                    color: Colors.yellow,
                                                  )
                                                : Text(""),
                                          ),
                                        ],
                                      ),
                                      Text(i.toMap()['description'],
                                          style: TextStyle(
                                              // color: Colors.white,
                                              fontFamily: 'Montserrat')),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            DateTime.now()
                                                        .millisecondsSinceEpoch >
                                                    i.toMap()['deadline']
                                                ? 'Overdue'
                                                : "${DateTime.fromMillisecondsSinceEpoch(i.toMap()['deadline']).difference(DateTime.now()).inDays} Days ${DateTime.fromMillisecondsSinceEpoch(i.toMap()['deadline']).difference(DateTime.now()).inHours} Hours",
                                            style: TextStyle(
                                              color: DateTime.now()
                                                          .millisecondsSinceEpoch >
                                                      i.toMap()['deadline']
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ).animate().shake().scale(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showTaskActionDialog({TasksModel? tasks}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: TasksActions(
                task: tasks,
              ),
              title: Text(
                "Add a Task",
                style: Constants.titleTheme,
              ),
            )).then((value) {
      _getTasks();
      final navigationState = navigationKey.currentState!;
      navigationState.setPage(0);
    });
  }
}
