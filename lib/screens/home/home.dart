import 'package:cookbook/models/categories.dart';
import 'package:cookbook/screens/home/detailpage.dart';
import 'package:cookbook/screens/home/favourites.dart';
import 'package:cookbook/screens/home/profile.dart';
import 'package:cookbook/screens/home/search.dart';
import 'package:cookbook/services/api/categories.dart';
import 'package:cookbook/services/api/recipes.dart';
import 'package:cookbook/services/auth.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
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
  final AuthService _auth= AuthService();

  List trendingRecipes=[];
  List topRecipes=[];
  List recommendedRecipes=[];
  Map data;
  bool isLoading= true;
  List<CategoryClass> categories=[];
  
  Future<void> getRecipes() async {
    data = await RecipeAPI.getRecipes();
    categories = await CategoriesAPI.getCategories();
    
    setState(() {
    topRecipes = data['popular'];
    trendingRecipes = data['trending'];
    recommendedRecipes = data['recommended'];
    });

    setState(() {
      isLoading=false;
    });        
  }  

  @override
  void initState() {    
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: GoogleFonts.montserratTextTheme(),
        
        title: Text(
          "Explore!", 
          style: TextStyle(fontSize: 30, color: Colors.black,),          
          ),
        toolbarHeight: 80.0,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.redAccent, size: 26,), 
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Favourites()));
                }
                ),
                SizedBox(width: 10,)
            ],
          )
        ],
      ),
      drawer: sideDrawer(),
      body: Column(
        children: [
           GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SearchPage(Categories(categories))));
            },                  
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [                      
                        Text("Search",),
                        Icon(
                          Icons.search,                           
                        )
                      ],
                    ),
                  )
                ),
            ),
          ),                   
          Expanded(            
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),        
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      
                      isLoading?
                        CategoriesLoadingPlaceHolder()
                      : Categories(categories),

                      SizedBox(height:15),                
                      SubHeadding(
                        string1: "Trending",
                        string2: "Recipes"
                      ),
                      SizedBox(height:7.5),

                      isLoading? 
                        TrendingRecipesLoadingPlaceholder()
                        :Container(                  
                          height: 300,                        
                          child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: trendingRecipes.length,
                                  itemBuilder: (_,index) {
                                    return InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_)=>DetailsPage(trendingRecipes[index])));
                                      },
                                      child: RecipeTile2(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                               
                                               Hero(
                                                 tag: "${trendingRecipes[index].recipeId}",
                                                 child: CircleAvatar(
                                                    radius: 75,
                                                    backgroundImage: NetworkImage(trendingRecipes[index].imageUrl),
                                                    backgroundColor: Colors.transparent,
                                                  ),
                                               ),
                                               SizedBox(height: 10,),                                                                              
                                              Text(
                                                "${trendingRecipes[index].name}", 
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,                                            
                                                  ),
                                                  overflow: TextOverflow.ellipsis,

                                                ),
                                              Text("${trendingRecipes[index].cuisine}"),
                                              SizedBox(height: 7.5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  StarRating(stars: trendingRecipes[index].rating??4,size: 18,),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(                                          
                                                    child: Row(                                                
                                                      children: [
                                                        Icon(Icons.timer, size: 14,),
                                                        Text("  ${(trendingRecipes[index].time/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),

                                                  Container(                                                                                                
                                                      child: Row(                                                  
                                                        children: [
                                                          Icon(Icons.local_fire_department_outlined, size: 13,),
                                                          Text("  ${trendingRecipes[index].calories} KCAL", style: TextStyle(fontSize: 12)),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              

                                              ],
                                              ),
                                          ),
                                        
                                    );
                                  },
                                )
                      ),

                      SizedBox(height:7.5),
                      SubHeadding(
                        string1: "Recommended",
                        string2: "Recipes"
                      ),

                      SizedBox(height:15),

                      isLoading?
                        RecommendedRecipesLoadingPlaceholder()
                        :Container(                                    
                        height: 200,                  
                        child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: recommendedRecipes.length,
                                  itemBuilder: (_,index) {
                                    return InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_)=>DetailsPage(recommendedRecipes[index])
                                          ));
                                      },
                                      child: Stack(
                                        children: [

                                          RecipeTile3(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [                                                                                                                               
                                                  Text(
                                                    "${recommendedRecipes[index].name}", 
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                      ),
                                                      overflow: TextOverflow.ellipsis,                                              
                                                    ),
                                                  Text("${recommendedRecipes[index].cuisine}"),
                                                  SizedBox(height: 10,),
                                                  StarRating(stars: recommendedRecipes[index].rating??4,size: 18,),
                                                  SizedBox(height: 15,),
                                                  Container(                                          
                                                    child: Row(                                                
                                                      children: [
                                                        Icon(Icons.timer, size: 14,),
                                                        Text("  ${(recommendedRecipes[index].time/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(                                                                                                
                                                      child: Row(                                                  
                                                        children: [
                                                          Icon(Icons.local_fire_department_outlined, size: 13,),
                                                          Text("  ${recommendedRecipes[index].calories} KCAL", style: TextStyle(fontSize: 12)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Container(                                                                                                
                                                      child: Row(                                                  
                                                        children: [
                                                          Icon(Icons.rice_bowl, size: 13,),
                                                          Text("  ${recommendedRecipes[index].servings} SERVINGS", style: TextStyle(fontSize: 12)),
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                  
                                                  ],
                                                  ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                  ),
                                                  child: Hero(
                                                    tag: "${recommendedRecipes[index].recipeId}",
                                                    child: CircleAvatar(
                                                            radius: 80,
                                                            backgroundImage: NetworkImage('${recommendedRecipes[index].imageUrl}'),
                                                            backgroundColor: Colors.transparent,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                        
                                    );
                                  },
                                )
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: SubHeadding(
                          string1: "Top",
                          string2: "Recipes",
                        ),
                      ),
                      isLoading?
                        TopRecipesLoadingPlaceholder()
                      : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: topRecipes.length,
                                itemBuilder: (_,index) {
                                  return InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_)=> DetailsPage(topRecipes[index])
                                        ));
                                    },
                                    child: RecipeTile1(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Hero(
                                            tag: '${topRecipes[index].recipeId}',
                                            child: CircleAvatar(
                                              radius: 75,
                                              backgroundImage: NetworkImage('${topRecipes[index].imageUrl}'),
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
                                                  "${topRecipes[index].name}", 
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                    ),
                                                    overflow: TextOverflow.ellipsis,                                              
                                                  ),
                                                Text("${topRecipes[index].cuisine}"),
                                                SizedBox(height: 10,),
                                                StarRating(stars: topRecipes[index].rating??4,size: 18,),
                                                SizedBox(height: 15,),
                                                Container(                                          
                                                  child: Row(                                                
                                                    children: [
                                                      Icon(Icons.timer, size: 14,),
                                                      Text("  ${(topRecipes[index].time/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Container(                                                                                                
                                                    child: Row(                                                  
                                                      children: [
                                                        Icon(Icons.local_fire_department_outlined, size: 13,),
                                                        Text("  ${topRecipes[index].calories} KCAL", style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(                                                                                                
                                                    child: Row(                                                  
                                                      children: [
                                                        Icon(Icons.rice_bowl, size: 13,),
                                                        Text("  ${topRecipes[index].servings} SERVINGS", style: TextStyle(fontSize: 12)),
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
                ),
            ),
          ),
        ],
      ),

    );
  }

  Widget sideDrawer(){
    return SafeArea(
        child: Drawer(
          child: Container(
            color: Colors.white,
            height: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),                                
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
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
                            
                        DrawerItem(
                          icon: Icons.person_outline_rounded,
                          text: "My Account",
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Profile()));
                          },                  
                        ),
                        DrawerItem(
                          icon: Icons.search_rounded,
                          text: "Search Recipes",
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SearchPage(Categories(categories))));
                          },       
                        ), 
                        DrawerItem(
                          icon: Icons.favorite_outline_rounded,
                          text: "Favorite Recipes",
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Favourites()));
                          },       
                        ), 

                        DrawerItem(
                          icon: Icons.settings_outlined,
                          text: "Settings",
                          onPressed: (){},        
                        ),   
                                       
                        DrawerItem(
                          icon: Icons.logout_rounded,
                          text: "Logout",
                          onPressed: () async {
                            _auth.isAnon()?
                              await _auth.deleteUser()
                            : await _auth.signOut();
                          },                  
                        ),                               
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        Text("Version 1.0.0.1", style: TextStyle(color: Colors.grey)),
                        // Text("Harsh Goyal", style: TextStyle(color: Colors.grey)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     TextButton(
                        //       onPressed: (){},
                        //       child: Text("Contribute", style: TextStyle( color: Colors.grey,)),                                                    
                        //     ),
                        //     Text("•", style: TextStyle(color: Colors.grey),),
                        //     TextButton(
                        //       onPressed: (){},
                        //       child: Text("Connect", style: TextStyle( color: Colors.grey,)),                                                    
                        //     ),
                        //   ],
                        // ),
                      ],                   
            
                    ),
            
                  ),
                ],
              ),
            
          )
        ),
      );
  }

}

class CategoriesLoadingPlaceHolder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 125,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => 
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[200],
              child: Container(       
                  width: 115,        
                  alignment: Alignment.center,        
                  margin: EdgeInsets.symmetric(vertical:10.0,horizontal:0.0),
                  decoration: BoxDecoration(
                      color:Colors.grey,
                      shape: BoxShape.circle,                    
                  ), 
                ),
            ),
         ),
    );
  }
}

class TrendingRecipesLoadingPlaceholder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(                  
      height: 300,                        
      child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (_,index) {
                  return RecipeTile2(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Shimmer.fromColors( 
                                baseColor: Colors.grey[300], 
                                highlightColor: Colors.grey[100],
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey
                                  ),
                                ),
                                ),                              
                              SizedBox(height: 10,),                                                                              
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
                              )
                            ),
                            SizedBox(height: 7.5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
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
                            ],
                            ),
                        );
                },
              )        
      
    );
  }
}

class RecommendedRecipesLoadingPlaceholder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height:200,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (_,index) {
          return Stack(
              children: [
                RecipeTile3(
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Shimmer.fromColors( 
                          baseColor: Colors.grey[300], 
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey
                            ),
                          ),
                          ),
                      ),
                    ),
              ],
            );
        },
      )
    );
  }
}

class TopRecipesLoadingPlaceholder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_,index) {
        return InkWell(
          onTap: (){},
          child: RecipeTile1(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Shimmer.fromColors( 
                  baseColor: Colors.grey[300], 
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: 160,
                    width: 160,
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
          ),
        );
      },
    );
  }
}