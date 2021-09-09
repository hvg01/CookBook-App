import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'recipetiles.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final CollectionReference refToRecipes= FirebaseFirestore.instance.collection('recipes');
  // ignore: unused_field
  final AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser.isAnonymous?
    Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      
      ),
      body: SafeArea(
        child: DefaultMessageForAnonUsers(message: "Sign in to see your Favourites!",)
      ),
    ):
    Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        textTheme: GoogleFonts.montserratTextTheme(),
        title: Text("Favourite Recipes", style: TextStyle(fontSize: 30),),
        toolbarHeight: 100.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (_,index) {
                  return InkWell(
                    onTap: (){},
                    child: RecipeTile1(
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
              )
      ),
    );
  }
}
