import 'package:flutter/material.dart';

import 'home.dart';

bool found = false;
String dpUrl = '';
String posts = '';
bool noInternet = false;
String followers = '';
String following = '';
bool isPrivate = false;
bool isVerified = false;
String fullName = '';
String biography = '';
String externalUrl = '';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
