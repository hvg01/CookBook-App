import 'package:cookbook/models/recipe.dart';
import 'package:cookbook/models/users.dart';
import 'package:cookbook/services/auth.dart';
import 'package:cookbook/services/database.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {

  final Recipe recipe;

  DetailsPage(this.recipe);
  
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  
  bool favMarked = false;
  AuthService _auth = new  AuthService();

  updateFavMarker() async {
    bool isMarked = await DatabaseService(_auth.userUid()).isRecipeInFavourites(widget.recipe.recipeId);  
    setState(() {
      favMarked = isMarked;
    });
    } 
  
  @override
  void initState() {
    super.initState();

    updateFavMarker();
  }
        
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);     
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: BackButton(color: Colors.black,),
        toolbarHeight: 75,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  favMarked? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: favMarked? Colors.redAccent: Colors.black,
                ),
                onPressed: () {
                    if (favMarked == true){
                      setState(() {
                        favMarked = !favMarked;
                      });  
                      DatabaseService(user.uid).deleteFromFavourites(widget.recipe); 
                                                                      
                    }
                    else{
                      setState(() {
                        favMarked = !favMarked;
                      });
                      DatabaseService(user.uid).addToFavourites(widget.recipe);
                      
                    }
                  
                },
              ),              
              SizedBox(width: 10,)
            ],
          )
        ],
        
      ),

      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${widget.recipe.name}", 
                          style: GoogleFonts.breeSerif(
                            fontSize: 36,
                            color: Colors.black,
                          ),                          
                        ),
                        Text(
                          "${widget.recipe.cuisine}",
                          style: TextStyle(
                            fontSize: 18,                      
                          ),                    
                        ),
                        SizedBox(height: 10,),
                        StarRating(stars: widget.recipe.rating??4,)
                    ],
                  ),
                
            ),
            SizedBox(height: 5,),
            Container(
              child: Stack(              
                children: [                
                  Container(
                    height: 300,                                                         
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        detailsInfoTile(value: widget.recipe.calories, text: "CALORIES", width: 165.0),
                        detailsInfoTile(value: widget.recipe.servings, text: "SERVES", width: 150.0),
                        detailsInfoTile(value: (widget.recipe.time/60).round(), text: "MINUTES", width: 165.0)
                      ],
                    ),
                                     
                  ),
                  Positioned(
                    right: -90,
                    top:15,
                    child: Container(
                      child: Hero(
                        tag: "${widget.recipe.recipeId}",
                        child: Container(
                          padding: EdgeInsets.all(25),                        
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            shape: BoxShape.circle
                          ),
                          child: CircleAvatar(                      
                            radius: 115,
                            backgroundImage: NetworkImage("${widget.recipe.imageUrl}"),
                            backgroundColor: Colors.transparent,
                            ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(                
                children:[
                                    
                  SubHeadding(
                    string1: "Ingredients",
                    string2: "",
                  ),
                  Container(                    
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      itemCount: widget.recipe.ingredients.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_,index)=> Container(      
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            
                            child: Text("•  "+
                              "${widget.recipe.ingredients[index]}",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),                        
                          ),
                        
                      
                      ) ,
                  ),
                  
                  SizedBox(height: 10,),
                  SubHeadding(
                    string1: "Steps",
                    string2: "",
                  ),

                  Container(                    
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      itemCount: widget.recipe.steps.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_,index)=> Container(      
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            
                            child: Text("${index+1}"+".  "+
                              "${widget.recipe.steps[index]}",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ), 
                      
                      ) ,
                  ),                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Happy ",
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                      Text(
                        "Cooking! ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                 
                ]
                
              ),

            )

          ],
        ),
      )

    );
  }
  Widget detailsInfoTile({value, text, double width}){ 
    return Container(
      height: 60,
      width: width,      
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,                          
        borderRadius: BorderRadius.circular(100),                        
        
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber[800]
            ),
            child: Center(child: Text("$value", style: TextStyle(color: Colors.white),)),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 10),
            child: Text(text),
          )
        ]                          
      ),
    );
  }  
}
