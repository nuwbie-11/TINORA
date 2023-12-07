import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinora/model/profile_model.dart';
import 'package:tinora/model/tasks_model.dart';
import 'package:tinora/pages/auth_page.dart';
import 'package:tinora/provider/profile_provider.dart';
import 'package:tinora/provider/tasks_provider.dart';

class HomePages extends StatefulWidget {
  final ProfileModel? profile;
  final TasksModel? tasks;
  const HomePages({Key? key, this.profile, this.tasks}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());
  String dayName = DateFormat('EEEE, MMMM yyyy').format(DateTime.now());
  late Timer _timer;
  Map _userActive = {};
  List<TasksModel> _task = [];

  @override
  void initState() {
    super.initState();
    findProfile();
    createTask();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  void _update() {
    setState(() {
      formattedDate = DateFormat('kk:mm').format(DateTime.now());
    });
  }

  createProfile() async {
    final ProfileModel model = ProfileModel(
      userId: 3,
      name: "Mondoes",
      level: 10,
      experience: 0.0,
      id: widget.profile?.id,
    );
    if (widget.profile == null) {
      await ProfileProvider.addProfile(model);
      print("Finished");
    }
  }

  createTask() async {
    final TasksModel model = TasksModel(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      deadline: DateTime(2024, 12, 30, 0, 0).millisecondsSinceEpoch,
      description: "REMINDER OF YK",
      id: widget.tasks?.id,
      isImportant: 1,
    );
    if (widget.tasks == null) {
      await TasksProvider.addTasks(model);
      print("Finished");
    }
    TasksProvider.getAllTasks().then((value) => setState(() {
          _task = value!;
        }));
  }

  findProfile() async {
    final SharedPreferences prefs = await _prefs;
    final int? userId = prefs.getInt('user');
    ProfileProvider.findProfile(userId!).then((value) => setState(() {
          _userActive = value!;
        }));
  }

  logOut() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: "Circle",
          ),
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        child: Column(
          children: [
            Container(
              width: screenWidth,
              color: Colors.blue,
              height: screenHeight / 5,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 15,
                ),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _userActive.containsKey(
                            'name',
                          )
                              ? Text(
                                  _userActive['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    fontSize: 10,
                                  ),
                                )
                              : const Text("..."),
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
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        child: Center(child: Text("Tasks")),
                        height: 30,
                        width: screenWidth,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  createTask();
                                  // createProfile();

                                  // logOut();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => AuthPages()));
                                  // findProfile();
                                },
                                icon: const Icon(Icons.exit_to_app),
                                label: const Text("Exit"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      // crossAxisSpacing: 8,
                      children: [
                        for (var i in _task)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Draggable(
                              childWhenDragging: null,
                              feedback: Material(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade400,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      i.toMap()['description'],
                                      style: TextStyle(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        i.toMap()['description'],
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    i.toMap()['deadline']))
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            DateTime.now()
                                                        .millisecondsSinceEpoch >
                                                    i.toMap()['deadline']
                                                ? 'Overdue'
                                                : "${DateTime.fromMillisecondsSinceEpoch(i.toMap()['deadline']).difference(DateTime.now()).inDays} Days Remaining",
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
                            ),
                          ),
                      ],
                    ),
                    // ListView.builder(
                    //   itemCount: _task.length,
                    //   itemBuilder: (BuildContext context, int ix) {
                    //     return Container(
                    //       color: Colors.red,
                    //       child: Center(
                    //         child: Text((DateTime.fromMillisecondsSinceEpoch(
                    //                 _task[ix].toMap()['createdAt']))
                    //             .toString()),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
