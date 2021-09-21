import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/models/recipe.dart';
import 'package:cookbook/models/users.dart';

class DatabaseService {

String uid;
CollectionReference favouriteRecipe;
DatabaseService(this.uid){  
  // Collection reference for favourite recipes  
  favouriteRecipe = FirebaseFirestore.instance.collection("users").doc(uid).collection('favouriteRecipes');
}

  //collection reference for users
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData({String name, String email, String phone}) async{
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'email' : email,
    });
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){

    Map data = snapshot.data();
    return UserData(
      uid: uid,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
    );
  }

  Stream get favouriteRecipes{
    return favouriteRecipe.snapshots();
  }

  Future addToFavourites(Recipe recipe){

    return favouriteRecipe.doc(recipe.recipeId).set({
      'recipeId' : recipe.recipeId,
      'name' : recipe.name,
      'cuisine' : recipe.cuisine,
      'calories' : recipe.calories,
      'imageUrl' : recipe.imageUrl,
      'rating' : recipe.rating,
      'steps' : recipe.steps,
      'noOfSteps' : recipe.noOfSteps,
      'ingredients' : recipe.ingredients,
      'time' : recipe.time,
      'servings' : recipe.servings
    });  
  }

  Future<bool> isRecipeInFavourites(recipeId) async{
    var snapshot = await favouriteRecipe.doc(recipeId).get();
    if (snapshot != null && snapshot.exists){
      return true;
    }
    else return false;
  }

  Future deleteFromFavourites(Recipe recipe){
    return favouriteRecipe.doc(recipe.recipeId).delete();
  }

}
