import 'dart:convert';
import 'package:cookbook/models/categories.dart';
import 'package:cookbook/models/recipe.dart';
import 'package:http/http.dart' as http;


class CategoriesAPI{

  static Future<List> getCategories() async {

    var uriCategories = Uri.https('yummly2.p.rapidapi.com', '/categories/list', );

    final response = await http.get(uriCategories, headers: {
      "x-rapidapi-key": "c9a8e1f972mshf13baed91c7618ep101690jsnb9315070d9b8",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    final catergoriesData = jsonDecode(response.body);

    
    var _categoriesList=[];

    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][8]); //indian
    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][0]); //american    
    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][10]); //chineese
    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][4]); //mexican
    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][3]); //italian
    _categoriesList.add(catergoriesData["browse-categories"][8]['display']["categoryTopics"][5]); //french
        
    return CategoryList.categoriesFromSnapshot(_categoriesList);    
  }

}

class CategoryRecipesAPI{

  static Future<List> getCategoryRecipes(String tag) async{

    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "7", "start": "0", "tag": "$tag"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "c9a8e1f972mshf13baed91c7618ep101690jsnb9315070d9b8",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    var recipesData= json.decode(response.body);
     var _temp=[];

     for (var i in recipesData['feed']){
       _temp.add(i['content']);       
     }
     _temp.removeAt(1);
     return RecipesList.recipesFromSnapshot(_temp);

  }

}