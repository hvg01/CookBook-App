import 'package:flutter/material.dart';

class RecipeTile extends StatelessWidget {
  final Widget child;
  RecipeTile({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
        ),
        padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 20.0) ,
        margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
        height: MediaQuery.of(context).size.height*0.25,
        child: child,
      );
  }
}

