import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';



// Default Message widget and sign in prompt for anonymous users on Favourites, MyRecipe, AddRecipe and Profile

class DefaultMessageForAnonUsers extends StatefulWidget {
  final String message;
  DefaultMessageForAnonUsers({this.message});

  @override
  _DefaultMessageForAnonUsersState createState() => _DefaultMessageForAnonUsersState();
}

class _DefaultMessageForAnonUsersState extends State<DefaultMessageForAnonUsers> {

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Click here to '),
              TextButton(onPressed: ()async {FirebaseAuth.instance.currentUser.delete();}, child: Text('Sign in')),
            ],
          )
        ],
      ),
    );
  }
}

// Input field container for login and register pages

class InputContainer extends StatelessWidget {
  final Widget child;
  InputContainer({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey[100]),
      child: child,
    );
  }
}



