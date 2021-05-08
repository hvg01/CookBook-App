import 'package:flutter/material.dart';


class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["All", "Indian", "Italian", "Mexican", "Chinese"];

  // By default first one is selected
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height*0.15,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategoryItem(index),
        ),
      );
  }

  Widget buildCategoryItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.3,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 20.0) ,
        margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
        decoration: BoxDecoration(
            color:
            selectedIndex == index ? Colors.redAccent : Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          categories[index],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedIndex == index ? Colors.white : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
