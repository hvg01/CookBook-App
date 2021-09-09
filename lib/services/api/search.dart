// import 'package:cookbook/models/categories.dart';
// import 'package:cookbook/models/recipe.dart';
import 'dart:convert';
import 'package:cookbook/models/recipe.dart';
import 'package:http/http.dart' as http;

class SearchAPI {

  static String apiKey = "c9a8e1f972mshf13baed91c7618ep101690jsnb9315070d9b8";
  static String apiHost = "yummly2.p.rapidapi.com";

  static Future<List> getSearchResults(String searchText)async {

    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/search',
    {'maxResult': '10', 'start': '0', 'q': '$searchText'},
    );

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "c9a8e1f972mshf13baed91c7618ep101690jsnb9315070d9b8",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    var searchData=jsonDecode(response.body);

    List _temp=[];

    for (var i in searchData['feed']){
      _temp.add(i['content']);
    }

    return RecipesList.recipesFromSnapshot(_temp);

  }

}