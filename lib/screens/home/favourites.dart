import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/models/recipe.dart';
import 'package:cookbook/models/users.dart';
import 'package:cookbook/screens/home/detailpage.dart';
import 'package:cookbook/services/database.dart';
import 'package:cookbook/shared/loading.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    
    final user= Provider.of<Users>(context);

    return _auth.isAnon()?
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
        title: Text("Favourite Recipes", style: TextStyle(fontSize: 20, color: Colors.black,),),               
        toolbarHeight: 100.0,        
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: BackButton(color: Colors.black)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder(
          stream: DatabaseService(user.uid).favouriteRecipes,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              if(snapshot.data.docs.length==0){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Explore recipes and save them here!  ", style: TextStyle(fontSize: 16, ), textAlign: TextAlign.center,),
                        Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20,)
                      ],
                    ),
                                    
                    ]                    
                  );
              }
              else{
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_,index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                          DetailsPage(
                            Recipe(
                              name: snapshot.data.docs[index]['name'],
                              cuisine: snapshot.data.docs[index]['cuisine'],
                              imageUrl: snapshot.data.docs[index]['imageUrl'],
                              steps: snapshot.data.docs[index]['steps'],
                              noOfSteps: snapshot.data.docs[index]['noOfSteps'],
                              rating: snapshot.data.docs[index]['rating'],
                              time: snapshot.data.docs[index]['time'],
                              calories: snapshot.data.docs[index]['calories'],
                              recipeId: snapshot.data.docs[index]['recipeId'],
                              servings: snapshot.data.docs[index]['servings'],
                              ingredients: snapshot.data.docs[index]['ingredients']
                            )
                          )
                        ));
                        },
                        child: RecipeTile1(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                              radius: 75,
                                              backgroundImage: NetworkImage('${snapshot.data.docs[index]['imageUrl']}'),
                                              backgroundColor: Colors.transparent,
                                            ),                                          
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [                                                                                                                               
                                                Text(
                                                  "${snapshot.data.docs[index]['name']}", 
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                    ),
                                                    overflow: TextOverflow.ellipsis,                                              
                                                  ),
                                                Text("${snapshot.data.docs[index]['cuisine']}"),
                                                SizedBox(height: 10,),
                                                StarRating(stars: snapshot.data.docs[index]['rating']??4,size: 18,),
                                                SizedBox(height: 15,),
                                                Container(                                          
                                                  child: Row(                                                
                                                    children: [
                                                      Icon(Icons.timer, size: 14,),
                                                      Text("  ${(snapshot.data.docs[index]['time']/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Container(                                                                                                
                                                    child: Row(                                                  
                                                      children: [
                                                        Icon(Icons.local_fire_department_outlined, size: 13,),
                                                        Text("  ${snapshot.data.docs[index]['calories']} KCAL", style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(                                                                                                
                                                    child: Row(                                                  
                                                      children: [
                                                        Icon(Icons.rice_bowl, size: 13,),
                                                        Text("  ${snapshot.data.docs[index]['servings']} SERVINGS", style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),                                                    
                                                
                                                ],
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                      );
                    },
                  );
              }
            }  
            else{
              return Loading();
            }
            
          }
        )
      ),
    );
  }
}
