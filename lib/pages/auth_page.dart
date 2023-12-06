import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth - 80,
                height: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.75),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "TINORA",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(
                        color: Colors.black,
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
                              // final UserModel model = UserModel(
                              //   userName: "astra",
                              //   password: "1234",
                              //   id: widget.user?.id,
                              // );

                              // if (widget.user == null) {
                              //   await UserProvider.addUser(model);
                              // }
                              // UserProvider.getAllUsers()
                              //     .then((value) => print(value));

                              var userName = unameController.value.text;
                              var password = passwdController.value.text;
                              if (widget.user == null) {
                                var isAuth = await UserProvider.authUser(
                                    userName, password);
                                if (isAuth) {
                                  pushToMainPage();
                                }
                              }
                            },
                            icon: Icon(Icons.arrow_circle_right),
                            label: Text("Log In"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final void Function(dynamic) onChanged;
  final bool obscured;
  final TextInputType keyboardType;
  final bool formatted;
  final IconData usedIcon;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.obscured = false,
    this.keyboardType = TextInputType.text,
    this.formatted = false,
    required this.usedIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(usedIcon),
        ),
        Expanded(
          child: TextField(
            inputFormatters: [
              formatted
                  ? FilteringTextInputFormatter.deny(
                      RegExp(r'\s')) // Deny spaces
                  : FilteringTextInputFormatter.deny(RegExp(r'')),
            ],
            keyboardType: keyboardType,
            obscureText: obscured,
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
