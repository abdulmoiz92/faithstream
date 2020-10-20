import 'package:faithstream/model/category.dart';
import 'package:flutter/material.dart';

class SubCategoryPrefixList extends StatelessWidget {
  final bool mounted;
  final List<Category> allSubCategories;
  final int index;
  final BoxConstraints constraints;

  SubCategoryPrefixList(
      this.mounted, this.allSubCategories, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (mounted)
              Image.network(
                "${allSubCategories[index].iconUrl}",
                width: 50,
                height: 30,
              ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text("${allSubCategories[index].categoryName}"),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
