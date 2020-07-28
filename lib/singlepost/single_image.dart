import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SingleImage extends StatelessWidget {
  String imageUrl;

  SingleImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Center(
            child: Container(
              width: double.infinity,
              height: constraints.maxHeight * 1,
              child: PhotoView(imageProvider: NetworkImage(imageUrl),filterQuality: FilterQuality.high,minScale: PhotoViewComputedScale.contained,),
            ),
          );
        },
      ),
    );
  }
}
