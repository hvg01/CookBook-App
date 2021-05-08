import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/screens/home/recipetiles.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRecipes extends StatefulWidget {
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {

  final AuthService _auth= AuthService();
  final CollectionReference refToRecipes= FirebaseFirestore.instance.collection('recipes');

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser.isAnonymous?
    SafeArea(
      child: DefaultMessageForAnonUsers(message: "Sign in to see your Recipes!"),
    ):
    Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          textTheme: GoogleFonts.montserratTextTheme(),
          title: Text("My Recipes", style: TextStyle(fontSize: 30),),
          toolbarHeight: 100.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder(
            stream: refToRecipes.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (_,index) {
                  return InkWell(
                    onTap: (){},
                    child: RecipeTile(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundImage: AssetImage('assets/images/chicken_fried_rice.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text("Italian Steak", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("Italian"),
                                SizedBox(height:  MediaQuery.of(context).size.height*0.02,),
                                Text("Time: 20 minutes"),
                                SizedBox(height:  MediaQuery.of(context).size.height*0.05,),
                                TextButton.icon(icon: Icon(Icons.favorite, color: Colors.redAccent,),label:Text('Mark\nFavourite', style: TextStyle(color: Colors.redAccent),), onPressed: (){},),
                              ],

                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        ),
      ),
    );
  }
}
