import 'package:cookbook/models/users.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);

    return FirebaseAuth.instance.currentUser.isAnonymous?
    SafeArea(
      child: DefaultMessageForAnonUsers(message: "Sign in to see Profile!",)
    ):
    Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.1),
        brightness: Brightness.light,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('logout  ', style: TextStyle(color: Colors.black),),
            icon: Icon(Icons.logout, color: Colors.black,),
          )
        ],
      ),
       body: Text('User login')

      );

  }
}
