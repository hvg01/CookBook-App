import 'package:cookbook/services/auth.dart';
import 'package:cookbook/shared/constants.dart';
import 'package:cookbook/shared/loading.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});
  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool loading= false;

  final AuthService _auth= AuthService();
  final _formKey= GlobalKey<FormState>();

  //text field state
  String email='';
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
                          Text("Sign In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          SizedBox(height: 15,),
                          InputContainer(
                            child: TextFormField(
                              validator: (val)=>val.isEmpty? 'Enter your email' : null,
                              cursorColor: Colors.redAccent,
                              decoration: textInputDecoration.copyWith(
                                  icon: Icon(Icons.email_outlined, color: Colors.redAccent, ),
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
                              validator: (val)=>val.isEmpty? 'Enter your password' : null,
                              obscureText: true,
                              cursorColor: Colors.redAccent,
                              decoration: textInputDecoration.copyWith(
                                icon: Icon(Icons.lock_outline, color: Colors.redAccent,),
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
                                    dynamic result= await _auth.signInWithEmailAndPassword(email, password);
                                    if (result==null) {
                                      setState(() async {
                                        loading=false;
                                        error= "Invalid Email or Password";
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
                                child: Text("Sign in", style: TextStyle(color: Colors.white),)
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                child: Text('Sign Up'),
                                onPressed: (){
                                  widget.toggleView();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 50,),
                          TextButton.icon(
                            icon: Text("Skip Login", style: TextStyle(color: Colors.black),),
                            label: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                            onPressed: () async{
                              setState(()=>loading=true);
                              await _auth.signInAnon();
                            },
                          )
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
