import 'package:cookbook/services/auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';


class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // ignore: unused_field
  final AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: Home(),

    );
  }
}
