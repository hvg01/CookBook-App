import 'package:cookbook/screens/authenticate/authenticate.dart';
import 'package:cookbook/screens/home/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/models/users.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);

    if (user==null){ 
      
      return Authenticate();
    }
    else {
      return MainPage(); 
    }


  }
}
