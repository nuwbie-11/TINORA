// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinora/constants.dart';
import 'package:tinora/model/user_model.dart';
import 'package:tinora/pages/home_pages.dart';

class LandingPages extends StatefulWidget {
  final UserModel? user;
  const LandingPages({Key? key, this.user}) : super(key: key);

  @override
  State<LandingPages> createState() => _LandingPagesState();
}

class _LandingPagesState extends State<LandingPages> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  setPrefs() async {
    var prefs = await _prefs;
    prefs.setBool('user', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Constants.picture),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Track Your Doing and Reward Yourself !!",
                      style: Constants.titleWhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 150,
            alignment: Alignment.center,
            // color: Colors.amber,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  )),
              child: Row(
                children: [
                  _buildButtons(
                      label: "Let's Go !!",
                      color: Colors.white,
                      function: () {
                        setPrefs();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePages()));
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_buildButtons({String? label, Color? color, required Function() function}) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? Colors.transparent,
      ),
      child: TextButton(
        onPressed: function,
        child: Text(
          label ?? "...",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color != null ? Colors.deepPurple : Colors.white,
          ),
        ),
      ),
    ),
  );
}
