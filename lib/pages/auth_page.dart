// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tinora/Components/custom_textfield.dart';
import 'package:tinora/constants.dart';
import 'package:tinora/model/user_model.dart';
import 'package:tinora/pages/home_pages.dart';
import 'package:tinora/provider/user_provider.dart';

class AuthPages extends StatefulWidget {
  final UserModel? user;
  AuthPages({Key? key, this.user}) : super(key: key);

  @override
  State<AuthPages> createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  void pushToMainPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomePages()));
  }

  final unameController = TextEditingController();
  final passwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.75),
            color: Constants.notWhite.withOpacity(0.82),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Tinora",
                  style: Constants.titleTheme,
                ),
              ),
              SizedBox(
                width: screenWidth - 120,
                child: CustomTextField(
                  controller: unameController,
                  hint: "Username",
                  onChanged: (value) {},
                  formatted: true,
                  usedIcon: Icons.person,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: screenWidth - 120,
                child: CustomTextField(
                  controller: passwdController,
                  hint: "Password",
                  onChanged: (value) {},
                  obscured: true,
                  formatted: true,
                  usedIcon: Icons.key,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var userName = unameController.value.text;
                        var password = passwdController.value.text;
                        if (widget.user == null) {
                          var isAuth =
                              await UserProvider.authUser(userName, password);
                          if (isAuth) {
                            pushToMainPage();
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_right),
                      label: Text("Log In"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
