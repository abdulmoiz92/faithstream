import 'package:flutter/cupertino.dart';

class Category {
  String iconUrl;
  String categoryName;
  int categoryId;
  int numOfSteps;

  Category({@required this.iconUrl,@required this.categoryName,@required this.categoryId,this.numOfSteps});
}