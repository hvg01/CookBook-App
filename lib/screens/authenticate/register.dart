import 'package:cookbook/shared/constants.dart';
import 'package:cookbook/shared/loading.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool loading= false;

  final AuthService _auth= AuthService();
  final _formKey= GlobalKey<FormState>();
  //text field state
  String name='';
  String email='';
  String phone='';
  String password='';
  String error='';


  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(child: Image.asset('assets/images/chicken_fried_rice.png', height: 200,), top: -60, left: -60),
              Container(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100),
                        Image.asset('assets/images/cookbook.png', height: 120,),
                        SizedBox(height: 25,),
                        Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),

                        InputContainer(
                          child: TextFormField(
                            validator: (val)=>val.isEmpty? 'Enter a name' : null,
                            cursorColor: Colors.redAccent,
                            decoration: textInputDecoration.copyWith(
                              icon:Icon(Icons.person_outline, color: Colors.redAccent,),
                              hintText: 'Name',
                            ),
                            onChanged: (val) {
                              setState(()=> name=val);
                            },
                          ),
                        ),
                        SizedBox(height: 20,),
                        InputContainer(
                          child: TextFormField(
                            validator: (val)=>val.isEmpty? 'Enter an email' : null,
                            cursorColor: Colors.redAccent,
                            decoration: textInputDecoration.copyWith(
                            icon: Icon(Icons.email_outlined, color: Colors.redAccent),
                            hintText: 'Email'
                            ),
                            onChanged: (val) {
                              setState(()=> email=val);
                            },
                          ),
                        ),
                        SizedBox(height: 20,),
                        InputContainer(
                          child: TextFormField(
                            validator: (val)=>val.length<10? 'Enter a valid phone number' : null,
                            cursorColor: Colors.redAccent,
                            decoration: textInputDecoration.copyWith(
                            icon: Icon(Icons.phone_outlined, color: Colors.redAccent),
                            hintText: 'Phone'
                            ),
                            onChanged: (val) {
                              setState(()=> phone=val);
                            },
                          ),
                        ),                        
                        SizedBox(height: 20,),
                        InputContainer(
                          child: TextFormField(
                            validator: (val)=>val.length<8? 'Minimum 8 characters' : null,
                            obscureText: true,
                            cursorColor: Colors.redAccent,
                            decoration: textInputDecoration.copyWith(
                              icon: Icon(Icons.lock_outline, color: Colors.redAccent),
                              hintText: 'Password',
                            ),
                            onChanged: (val) {
                              setState(()=> password=val);
                            },
                          ),
                        ),
                        SizedBox(height: 20,),                        
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.redAccent),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                              ),
                              onPressed: () async {
                                if(_formKey.currentState.validate()){
                                    setState(()=>loading=true);
                                    dynamic result= await _auth.registerWithEmailAndPassword(name, email, phone, password);
                                  if (result==null) {
                                    setState(() async {
                                      loading=false;
                                      error= "Enter a valid email id!";
                                    });
                                    final snackBar = SnackBar(
                                      content: Text(error),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                }
                              },
                              child: Text("Register", style: TextStyle(color: Colors.white),)
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                              child: Text('Sign In'),
                              onPressed: (){
                                widget.toggleView();
                              },
                            ),
                          ],
                        ),
                        // SizedBox(height: 20,),
                        // TextButton.icon(
                        //   icon: Text("Skip Login", style: TextStyle(color: Colors.black),),
                        //   label: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                        //   onPressed: ()async{
                        //     setState(()=>loading=true);
                        //     await _auth.signInAnon();
                        //   },
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
