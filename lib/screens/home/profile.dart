import 'package:cookbook/models/users.dart';
import 'package:cookbook/services/database.dart';
import 'package:cookbook/shared/loading.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  AuthService _auth= AuthService();   
  

  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);    

    return _auth.isAnon()?
    Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),        
      ),
      body: SafeArea(
        child: DefaultMessageForAnonUsers(message: "Sign in to see Profile!",)
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        textTheme: GoogleFonts.montserratTextTheme(),
        title: Text("My Account", style: TextStyle(fontSize: 20),),               
        toolbarHeight: 100.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: BackButton(color: Colors.black)
      ),
      backgroundColor: Colors.grey[100],
      
        body: SingleChildScrollView(
          child: SafeArea(
            child: StreamBuilder<UserData>(
              stream: DatabaseService(user.uid).userData,
              builder: (context, snapshot) {
                return 
                snapshot.hasData?                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),                                
                        child: Container(
                          height: 175,
                          width: 175,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                    ProfilePageListTile(placeholder: "Name", value: "${snapshot.data.name}",),
                    ProfilePageListTile(placeholder: "Email", value: "${snapshot.data.email}",),
                    ProfilePageListTile(placeholder: "Phone",value:"${snapshot.data.phone}",),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(25, 45, 25, 5), 
                      padding: EdgeInsets.symmetric(horizontal: 20),                 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber[100],                    
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Buy Premium Membership", style: TextStyle(color: Colors.brown),),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.amber[800]
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                            _auth.isAnon()?
                              await _auth.deleteUser()
                            : await _auth.signOut();
                          },  
                        child: Text("Logout", style: TextStyle(color: Colors.grey[600]),),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey[200])),
                      )
                    )  
                  ],
                )
               :Column(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [                   
                   Center(child:Loading()),
                 ],
               );
              }
            ),
          ),
        ),
       
      );

  }
}
