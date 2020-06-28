import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignIn.dart';
import 'bookmark.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? SignIn() : BookMark()
  ));
}
