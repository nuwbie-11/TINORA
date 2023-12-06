import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinora/model/profile_model.dart';
import 'package:tinora/pages/auth_page.dart';
import 'package:tinora/provider/profile_provider.dart';

class HomePages extends StatefulWidget {
  final ProfileModel? profile;
  const HomePages({Key? key, this.profile}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());
  String dayName = DateFormat('EEEE, MMMM yyyy').format(DateTime.now());
  late Timer _timer;
  Map _userActive = {};

  @override
  void initState() {
    super.initState();
    findProfile();
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
      userId: 1,
      name: "Astra Bilis",
      level: 100,
      experience: 0.0,
      id: widget.profile?.id,
    );
    if (widget.profile == null) {
      await ProfileProvider.addProfile(model);
      print("Finished");
    }
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
                                  logOut();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AuthPages()));
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
