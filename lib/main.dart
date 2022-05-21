// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/welcome_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real estate',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: WelcomeScreen(),
    );
  }
}
