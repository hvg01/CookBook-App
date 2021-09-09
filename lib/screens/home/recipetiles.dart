import 'package:flutter/material.dart';

class RecipeTile1 extends StatelessWidget {
  final Widget child;
  RecipeTile1({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(            
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0)
        ),
        padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 10.0) ,
        margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
        height: 200,
        child: child,
      ); 
  }
}

class RecipeTile2 extends StatelessWidget {
  final Widget child;
  RecipeTile2({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
        ),
        padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 20.0) ,
        margin: EdgeInsets.fromLTRB(10, 12.5, 10, 12.5),
        width: 200,
        //height: 260,
        child: child,
      );
  }
}

class RecipeTile3 extends StatelessWidget {
  final Widget child;
  RecipeTile3({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),),
            color: Colors.white
        ),
        padding: EdgeInsets.fromLTRB(100, 10, 20, 0) ,
        margin: EdgeInsets.fromLTRB(90, 5, 10, 5),
        width: 240,
        //height: 260,
        child: child,
      );
  }
}
