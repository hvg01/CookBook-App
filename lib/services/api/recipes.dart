import 'dart:convert';
import 'package:cookbook/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeAPI {

  static String apiKey = "c9a8e1f972mshf13baed91c7618ep101690jsnb9315070d9b8";
  static String apiHost = "yummly2.p.rapidapi.com";

  static Future<Map> getRecipes() async {
    var uriPopular = Uri.https('$apiHost', '/feeds/list',
        {"limit": "3", "start": "5", "tag": "list.recipe.trending"});
    
    var uriTrending = Uri.https('$apiHost', '/feeds/list',
        {"limit": "10", "start": "2", "tag": "list.recipe.popular"});

    var uriRecommended = Uri.https('$apiHost', '/feeds/list',
        {"limit": "5", "start": "5", "tag": "list.recipe.search_based:search:exp_sqe"});    


    final response = await Future.wait([
      http.get(uriPopular, headers: {
      "x-rapidapi-key": "$apiKey",
      "x-rapidapi-host": "$apiHost",
      "useQueryString": "true"
    }),

    http.get(uriTrending, headers: {
      "x-rapidapi-key": "$apiKey",
      "x-rapidapi-host": "$apiHost",
      "useQueryString": "true"
    }),

    http.get(uriRecommended, headers: {
      "x-rapidapi-key": "$apiKey",
      "x-rapidapi-host": "$apiHost",
      "useQueryString": "true"
    })

    ]);
        

    final popularJson = jsonDecode(response[0].body);
    final trendingJson = jsonDecode(response[1].body);
    final recommendedJson = jsonDecode(response[2].body);
    
    var _popularList=[];
    var _trendingList=[];
    var _recommendedList=[];
    

    for (var i in popularJson['feed']) {
      _popularList.add(i['content']);
    }
    for (var i in trendingJson['feed']) {
      _trendingList.add(i['content']);
    }
    for (var i in recommendedJson['feed']) {
      _recommendedList.add(i['content']);
    }

    return {
      'popular': RecipesList.recipesFromSnapshot(_popularList),
      'trending': RecipesList.recipesFromSnapshot(_trendingList),
      'recommended': RecipesList.recipesFromSnapshot(_recommendedList),
    };
  }
}

