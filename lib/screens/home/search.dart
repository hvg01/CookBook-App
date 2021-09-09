import 'package:cookbook/services/api/search.dart';
import 'package:cookbook/shared/constants.dart';
import 'package:cookbook/shared/loading.dart';
import 'package:cookbook/shared/widgets.dart';
import 'package:flutter/material.dart';

import 'detailpage.dart';

class SearchPage extends StatefulWidget {
  final Widget categories;
  SearchPage(this.categories);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List searchData=[];
  List data=[];
  bool empty = true;
  bool isLoading = false;
  bool found= true;
  TextEditingController text= TextEditingController(text: '');

  Future<void> getSearchResults() async {
    data = await SearchAPI.getSearchResults("${text.text}");    
    setState(() {
    searchData = data;    
  });
    setState(() {
      isLoading = false;
    });
    setState(() {
      if (searchData.isEmpty){
      found= false;                            
    }
    else found=true;                              
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black,),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [                        
              Center(
                child: Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100), 
                        color: Colors.white
                        ),
                      child: TextField( 
                        textInputAction: TextInputAction.search,
                        controller: text,                        
                        autofocus: true,                                
                        cursorColor: Colors.black,
                        enableInteractiveSelection: true,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Search',
                          fillColor: Colors.white,
                          focusColor: Colors.white,                        
                          hintStyle: TextStyle(fontSize: 14),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none                          
                            ),
                            contentPadding: EdgeInsets.all(0),
                          suffix: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: (){
                              isLoading = true;
                              getSearchResults();
                            },                          
                          ),
                        ),    
                        onChanged: (val) {
                          setState(() {    //to reset search                       
                            searchData=[];
                            found=true;
                          });                         
                           if (val!=''){
                            setState(() {
                              empty =false;                            
                            });
                           }
                          else if (val==''){
                            setState(() {
                              empty =true;
                            }); 
      
                          }
                        }, 
                        onSubmitted: (val){
                          setState(() {
                            isLoading = true;
                            getSearchResults();
                                                        
                          });
      
                        },                    
                      ),
                    ),
              ),
              empty?            
                Container(
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          child: widget.categories,
                        ),             
                      ),
                      Container(
                        child: Text(" Search for ingredients or food name",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                )                  
              : SizedBox(height: 20,),
              isLoading?
                Loading()
                :SizedBox(),
              searchResult(found)

      
              
                
      
      
                           
            ]
          ),
      ),
      
    );

  }

  Widget searchResult(bool found){
    if (found == true){
      return Container(
        color: Colors.grey[100],
        child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchData.length,
              itemBuilder: (_,index) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_)=>DetailsPage(searchData[index])
                      ));
                  },
                  child: Container(
                    decoration: BoxDecoration(            
                      color: Colors.white
                    ),
                    padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 10.0) ,
                    margin: EdgeInsets.symmetric(vertical:10.0,horizontal:7.0),
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "${searchData[index].recipeId}",
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage('${searchData[index].imageUrl}'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [                                                                                                                               
                              Text(
                                "${searchData[index].name}", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.ellipsis,                                              
                                ),
                              Text("${searchData[index].cuisine}"),
                              SizedBox(height: 10,),
                              StarRating(stars: searchData[index].rating??4,size: 18,),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(                                          
                                    child: Row(                                                
                                      children: [
                                        Icon(Icons.timer, size: 14,),
                                        Text("  ${(searchData[index].time/60).toInt()} MIN", style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Container(                                                                                                
                                  child: Row(                                                  
                                    children: [
                                      Icon(Icons.local_fire_department_outlined, size: 13,),
                                      Text("  ${searchData[index].calories} KCAL", style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                ],
                              ),
                                                            
                                                                                  
                              
                              ],
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
      );      
    }
    else return Container(
      child: Column(
        children: [
          SizedBox(height:50),
          Icon(Icons.search, size: 30, color: Colors.grey),
          Text("Try alternate phrases or try searching for main ingredient",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}