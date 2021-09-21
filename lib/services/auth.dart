import 'package:cookbook/models/users.dart';
import 'package:cookbook/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create users  object based on firebase user
  
  Users _userFromFirebaseUser(User user) {
    return user != null? Users(uid: user.uid): null;
  }

  //auth change user stream
  Stream<Users> get user{
    return _auth.authStateChanges()
    .map((_userFromFirebaseUser));
  }

  //signin for anonymous
Future signInAnon() async {
  try{
    UserCredential result= await _auth.signInAnonymously();
    User user= result.user;
    return _userFromFirebaseUser(user);
  }
  catch(e){
    print(e.toString());
    return null;
  }
}

//sign in with email and password
  Future signInWithEmailAndPassword(String email, String password)   async{
    try {
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user= result.user;      
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

//register with email and password
Future registerWithEmailAndPassword(String name, String email, String phone, String password)   async{
    try {
      UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user= result.user;
      //creating doc for user in firestor
      await DatabaseService(user.uid).updateUserData(name: '$name', email:'$email',phone: '$phone');

      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
}

//signout

Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
//is user Anonymous

  bool isAnon() {
    return  _auth.currentUser.isAnonymous;
  }

  Future deleteUser() async {
    try {
      return await _auth.currentUser.delete();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  String userUid() {
    return  _auth.currentUser.uid;
  }


}