import 'package:cookbook/screens/home/categoryrecipes.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/categories.dart';


class Categories extends StatefulWidget {

  final List<CategoryClass> categories;

  Categories(this.categories);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: widget.categories.length,
          itemBuilder: (context, index) => 
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CategoryRecipes(widget.categories[index])));        
              },
              child: Container(       
                width: 120,        
                alignment: Alignment.center,        
                margin: EdgeInsets.symmetric(vertical:0,horizontal:5.0),
                decoration: BoxDecoration(
                    color:Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage("${widget.categories[index].imageUrl}"),
                      fit: BoxFit.cover
                    )
                ),
                child: Text(
                  "${widget.categories[index].name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
         ),
    );
  }
}
