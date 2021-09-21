import 'dart:math';

class Recipe {

  final String name;
  final String  cuisine;
  final String imageUrl;
  var steps;
  int noOfSteps;
  var rating;
  int calories;
  final int time;
  int servings;
  final String recipeId;
  var ingredients;

  Recipe({
    this.name, 
    this.cuisine,
    this.imageUrl,
    this.steps,
    this.noOfSteps,
    this.rating,
    this.calories,
    this.time,
    this.recipeId,
    this.servings,
    this.ingredients
    });
}


class RecipesList{

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    
    List<Recipe> _temp=[];
    Random random = Random();

    for (var i in snapshot){
      _temp.add(Recipe(
       name: i['details']['name'] as String,
       cuisine: computeCuisine(i['tags']),
       imageUrl: i['details']['images'][0]['hostedLargeUrl'] as String,
       steps: computeSteps(i['preparationSteps'],i['preparationStepCount']),
       noOfSteps: i['preparationStepCount'] as int,
       rating: i['reviews']['averageRating'],
       time: i['details']['totalTimeInSeconds'] as int,
       calories: random.nextInt(250)+200,
       recipeId: i['details']['id'] as String,
       servings: i['details']['numberOfServings'] as int,
       ingredients: computeIngredients(i['ingredientLines'])
      ));
    }
    return _temp;
  }

  static String computeCuisine(cuisineData){

    if (cuisineData['cuisine'] == null){
      return 'American';
    }
    return cuisineData['cuisine'][0]['display-name'];
  }

  static List computeIngredients(ingredientsData){
    var ingredients=[];
    for (var i in ingredientsData) {
      ingredients.add(i['wholeLine']);
    } 
    return  ingredients;
  }

  static List computeSteps(stepsData, noOfSteps){
    var steps=[];
    for(var i=0; i<noOfSteps??0; i++){
      steps.add(stepsData[i]);
    }

    if (steps.isEmpty){
      
      return [
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh odio, tincidunt sed dui ac, mattis congue odio. Etiam in gravida nulla. Aenean eleifend erat nec dui imperdiet ultricies. Cras quis venenatis lorem, in porttitor tortor.',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh odio, tincidunt sed dui ac, mattis congue odio. Etiam in gravida nulla. Aenean eleifend erat nec dui imperdiet ultricies. Cras quis venenatis lorem, in porttitor tortor.',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh odio, tincidunt sed dui ac, mattis congue odio. Etiam in gravida nulla. Aenean eleifend erat nec dui imperdiet ultricies. Cras quis venenatis lorem, in porttitor tortor.',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nibh odio, tincidunt sed dui ac, mattis congue odio. Etiam in gravida nulla. Aenean eleifend erat nec dui imperdiet ultricies. Cras quis venenatis lorem, in porttitor tortor.'
      ];
    }
    else{
      
      return steps;
    }

    
  }
  
}