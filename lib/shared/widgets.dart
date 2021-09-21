import 'package:cookbook/screens/wrapper.dart';
import 'package:cookbook/services/auth.dart';
import 'package:flutter/material.dart';



// Default Message widget and sign in prompt for anonymous users on Favourites, MyRecipe, AddRecipe and Profile

class DefaultMessageForAnonUsers extends StatefulWidget {
  final String message;
  DefaultMessageForAnonUsers({this.message});

  @override
  _DefaultMessageForAnonUsersState createState() => _DefaultMessageForAnonUsersState();
}

class _DefaultMessageForAnonUsersState extends State<DefaultMessageForAnonUsers> {

    final AuthService _auth= AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Click here to'),
              TextButton(
                onPressed: ()async {                
                _auth.deleteUser();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Wrapper()), ModalRoute.withName("/"));
                }, 
                child: Text(
                  'Sign in', 
                  style: TextStyle(
                    color: Colors.amber[800], 
                    fontWeight: FontWeight.bold),
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Input field container for login and register pages

class InputContainer extends StatelessWidget {
  final Widget child;
  InputContainer({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey[100]),
      child: child,
    );
  }
}

class DrawerItem extends StatefulWidget {
  @required final Function onPressed;
  @required final IconData icon;
  @required final String text;

  DrawerItem({this.onPressed, this.icon, this.text});


  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),                  
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Colors.black),                        
            ),
          ),
          overlayColor: MaterialStateProperty.all(Colors.grey[200])
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [                        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Icon(
                widget.icon,
                color: Colors.amber[800],
              ),
            ),                        
            Text(
                widget.text,
                style: TextStyle(color: Colors.black, ),
              ),                        
          ],
        ),
      ),
    );
  }
}

class ProfilePageListTile extends StatefulWidget {

  final String placeholder;
  final String value;

  ProfilePageListTile({this.placeholder, this.value});


  @override
  _ProfilePageListTileState createState() => _ProfilePageListTileState();
}

class _ProfilePageListTileState extends State<ProfilePageListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 15,
                  width: 5,
                  color: Colors.amber[800],
                ),
                SizedBox(width: 15,),
                Text(
                  widget.placeholder,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ],
            ),
          ),          
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 25),            
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 16                             
                  ),
                  ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),

            ),
          ),
          SizedBox(height: 10,)         
        ],
        ),
    );
  }
}

class SubHeadding extends StatelessWidget {
  final String string1;
  final String string2;

  SubHeadding({this.string1, this.string2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(color: Colors.amber[800],height: 18, width:5),
        SizedBox(width:15),
        Text(string1 , style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(" "+string2, style:TextStyle(fontSize: 18)),                     
      ],                  
    );
  }
}


class StarRating extends StatelessWidget {
  final stars;
  final double size;
  StarRating({this.stars, this.size=24});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(        
        children: [
          Stack(
            children: [
              Icon(Icons.star, color: stars>1 ? Colors.yellow: Colors.transparent, size: size,),
              Icon(Icons.star_outline, color: Colors.amber[800].withOpacity(0.5), size: size,),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.star, color: stars>2 ? Colors.yellow: Colors.transparent, size: size,),
              Icon(Icons.star_outline, color: Colors.amber[800].withOpacity(0.5), size: size,),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.star, color: stars>3 ? Colors.yellow: Colors.transparent, size: size,),
              Icon(Icons.star_outline, color: Colors.amber[800].withOpacity(0.5), size: size,),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.star, color: stars>4 ? Colors.yellow: Colors.transparent, size: size,),
              Icon(Icons.star_outline, color: Colors.amber[800].withOpacity(0.5), size: size,),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.star, color: stars>=5 ? Colors.yellow: Colors.transparent, size: size,),
              Icon(Icons.star_outline, color: Colors.amber[800].withOpacity(0.5), size: size,),
            ],
          ),
        ]                             
            
      ),
    );
  }
}
