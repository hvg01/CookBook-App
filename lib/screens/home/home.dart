import 'package:cookbook/models/recipe.dart';
import 'categories.dart';
import 'package:cookbook/screens/home/recipetiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final CollectionReference refToRecipes= FirebaseFirestore.instance.collection('recipes');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        textTheme: GoogleFonts.montserratTextTheme(),
        title: Text("Explore!", style: TextStyle(fontSize: 30),),
        toolbarHeight: 100.0,
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.black,), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose a Cuisine", style:TextStyle(fontSize: 20,)),
                Categories(),
                SizedBox(height:20),
                StreamBuilder(
                    stream: refToRecipes.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
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
              ],
            ),
          ),
      ),

    );
  }
}

