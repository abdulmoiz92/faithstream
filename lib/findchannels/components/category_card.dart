import 'package:faithstream/findchannels/components/subcategory.dart';
import 'package:faithstream/model/category.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  List<Category> categoriesList;

  CategoryCard({@required this.categoriesList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return GridView.builder(
          itemCount: categoriesList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: constraints.maxWidth * 0.02,mainAxisSpacing: constraints.maxHeight * 0.04),
            itemBuilder: (cntx, index) {
              return Container(
                width: constraints.maxWidth * 0.3,
                child: LayoutBuilder(builder: (cntx,constr){
                 return GestureDetector(
                   onTap: () {Navigator.push(context, MaterialPageRoute(builder: (cntx) => SubCategoryScreen(numOfSteps: categoriesList[index].numOfSteps,catId: categoriesList[index].categoryId,)));},
                   child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.02),
                        child: Column(
                          children: <Widget>[
                            Container(padding: EdgeInsets.only(bottom: constr.maxHeight * 0.1),child: Image.network("${categoriesList[index].iconUrl}",width: constr.maxWidth * 1,height: constr.maxHeight * 0.5,)),
                            Text("${categoriesList[index].categoryName}",style: kTitleText.copyWith(fontSize: 12),)
                          ],
                        ),
                      ),
                    ),
                 );
                },),
              );
            });
      },
    );
  }
}
