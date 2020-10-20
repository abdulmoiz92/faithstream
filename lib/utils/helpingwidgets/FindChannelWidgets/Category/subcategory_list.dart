import 'package:faithstream/model/category.dart';
import 'package:flutter/material.dart';

class SubCategoryList extends StatelessWidget {
  final bool mounted;
  final List<Category> allSubCategories;
  final String groupName;
  final int index;
  final BoxConstraints constraints;

  SubCategoryList(this.mounted, this.allSubCategories, this.groupName,
      this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(),
          Container(
            width: constraints.maxWidth * 0.9,
            child: Padding(
              padding: groupName == "religion"
                  ? EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03)
                  : EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.0),
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
                    padding: groupName == "religion"
                        ? EdgeInsets.all(0)
                        : EdgeInsets.only(top: constraints.maxHeight * 0.03),
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
          ),
        ],
      ),
    );
  }
}
