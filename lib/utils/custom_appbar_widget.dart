import 'package:faithstream/searchscreens/search_channels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;

class CustomAppbarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: new IconThemeData(color: Colors.black87),
        title: Text(
          "FaithStream",
          style: TextStyle(color: Colors.black87, fontSize: 15),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                bs.showModalBottomSheet(
                    context: context,
                    builder: (cntx) => Search(),
                    barrierColor: Colors.white.withOpacity(0),
                    isScrollControlled: true,
                    enableDrag: false,
                    isDismissible: false);
              },
              child: Icon(
                Icons.search,
                color: Colors.black87,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white);
  }
}
