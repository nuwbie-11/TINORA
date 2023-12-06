import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinora/pages/auth_page.dart';
import 'package:tinora/pages/home_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogged = prefs.containsKey('user');
  runApp(MaterialApp(
    title: 'Tinora',
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(57, 68, 188, 1),
    ),
    home: isLogged ? HomePages() : AuthPages(),
  ));
}
