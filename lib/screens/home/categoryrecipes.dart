import 'package:cookbook/models/categories.dart';
import 'package:cookbook/services/api/categories.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'detailpage.dart';

class CategoryRecipes extends StatefulWidget {

  final CategoryClass category;
  CategoryRecipes(this.category);

  @override
  _CategoryRecipesState createState() => _CategoryRecipesState();
}

class _CategoryRecipesState extends State<CategoryRecipes> {

  List categoryRecipes=[];
  List data=[];
  bool isLoading = true;
  

  Future<void> getCategoryRecipes() async{
    data = await CategoryRecipesAPI.getCategoryRecipes('${widget.category.tag}');

    setState(() {
      categoryRecipes = data;
    });
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    
    getCategoryRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${widget.category.imageUrl}"),
                    fit: BoxFit.fill
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackButton(color: Colors.white,),

                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "${widget.category.name}", 
                      style: GoogleFonts.breeSerif(
                        fontSize: 36,
                        color: Colors.white,
                      ),                          
                    ),
                  ),
                  ]
                ),            
              ),
            ),

            isLoading?
              CategoryRecipesLoadingScreen()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: categoryRecipes.length,
                itemBuilder: (_,index) {
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_)=>DetailsPage(categoryRecipes[index])
                        ));
                    },
                    child: Container(
                      decoration: BoxDecoration(            
                        color: Colors.white
                      ),
                      padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 10.0) ,
                      margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Hero(
                            tag: '${categoryRecipes[index].recipeId}',
                            child: CircleAvatar(
                              radius: 85,
                              backgroundImage: NetworkImage('${categoryRecipes[index].imageUrl}'),
                              backgroundColor: Colors.transparent,
                            ),
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
                                  "${categoryRecipes[index].name}", 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                    ),
                                    overflow: TextOverflow.ellipsis,                                              
                                  ),
                                Text("${widget.category.name}"),
                                SizedBox(height: 10,),
                                StarRating(stars: categoryRecipes[index].rating??4,size: 18,),
                                SizedBox(height: 15,),
                                Container(                                          
                                  child: Row(                                                
                                    children: [
                                      Icon(Icons.timer, size: 14,),
                                      Text("  ${(categoryRecipes[index].time/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(                                                                                                
                                    child: Row(                                                  
                                      children: [
                                        Icon(Icons.local_fire_department_outlined, size: 13,),
                                        Text("  ${categoryRecipes[index].calories} KCAL", style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(                                                                                                
                                    child: Row(                                                  
                                      children: [
                                        Icon(Icons.rice_bowl, size: 13,),
                                        Text("  ${categoryRecipes[index].servings} SERVINGS", style: TextStyle(fontSize: 12)),
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
              )

          ],
        ),
        )
    );
  }
}

class CategoryRecipesLoadingScreen extends StatefulWidget {

  @override
  _CategoryRecipesLoadingScreenState createState() => _CategoryRecipesLoadingScreenState();
}

class _CategoryRecipesLoadingScreenState extends State<CategoryRecipesLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (_,index) {
                  return Container(
                        decoration: BoxDecoration(            
                          color: Colors.white
                        ),
                        padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 10.0) ,
                        margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
                        height: 200,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Shimmer.fromColors( 
                          baseColor: Colors.grey[300], 
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 170,
                            width: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey
                            ),
                          ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [                                                                                                                               
                                Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),                      
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),

                                                   
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),       
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    width: 125,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),       
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    width: 125,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),       
                                  ),
                                ),
                                  SizedBox(height: 10,),
                                  Shimmer.fromColors( 
                                  baseColor: Colors.grey[300], 
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 14, 
                                    width: 125,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)                                      
                                    ),       
                                  ),
                                ),
                                
                                ],
                                ),
                            ),
                          ),
                        ],
                      ),
                    );                
                },
              ) ;
  }
}