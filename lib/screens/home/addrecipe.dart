import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookbook/services/auth.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {

  final AuthService _auth= AuthService();
  
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser.isAnonymous?
    SafeArea(
      child: DefaultMessageForAnonUsers(message: "Sign in Add Recipe!",)
    ):
    Scaffold();
  }
}
