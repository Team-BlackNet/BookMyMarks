import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';
import 'bookmark.dart';
import 'viewbookmark.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
        BookMark.id: (context) => BookMark(),
        View.id: (context) => View(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}