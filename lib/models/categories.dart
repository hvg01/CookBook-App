class CategoryClass {
  
  final String name;
  final String imageUrl;
  final String tag; //for recipes in the category
  
  CategoryClass(  
  {
    this.name,
    this.imageUrl,
    this.tag
    }
  );
}

class CategoryList{

  static List<CategoryClass> categoriesFromSnapshot(List snapshot) {
    
    List<CategoryClass> _temp=[];
    
    for (var i in snapshot){
      _temp.add(CategoryClass(
        name: i["display"]["displayName"] as String,
        imageUrl: i["display"]['backgroundImage'] as String,
        tag: i["display"]['tag'] as String,        
      ));  
    }    
    return _temp;
  }


}