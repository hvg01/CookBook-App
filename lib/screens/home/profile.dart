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

  // ignore: unused_field
  final AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {

    // ignore: unused_local_variable
    final user= Provider.of<Users>(context);

    return FirebaseAuth.instance.currentUser.isAnonymous?
    Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),        
      ),
      body: SafeArea(
        child: DefaultMessageForAnonUsers(message: "Sign in to see Profile!",)
      ),
    ):
    Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),        
      ),
      backgroundColor: Colors.grey[100],
      
        body: SingleChildScrollView(

          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),                                
                    child: Container(
                      height: 175,
                      width: 175,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/cookbook.png'),
                          fit: BoxFit.contain,                                 
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(width: 1)
                      ),
                    ),
                  ),
                ),
                
                ProfilePageListTile(placeholder: "Name", value: "John Doe",),
                ProfilePageListTile(placeholder: "Email", value: "test@test.com",),
                ProfilePageListTile(placeholder: "Phone",value: "9999999999",),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(25, 55, 25, 10), 
                  padding: EdgeInsets.symmetric(horizontal: 20),                 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.amber[100],                    
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Buy Premium Membership", style: TextStyle(color: Colors.brown),),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.amber[800]
                      )
                    ],
                  ),
                  ),
                  

              ],
            ),
          ),
        ),
       
      );

  }
}
