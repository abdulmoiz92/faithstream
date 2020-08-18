import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SingleImage extends StatelessWidget {
  String imageUrl;
  Uint8List imageBytes;

  SingleImage(this.imageUrl,this.imageBytes);

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
              child: PhotoView(imageProvider: imageBytes == null ? NetworkImage(imageUrl) : MemoryImage(imageBytes),filterQuality: FilterQuality.high,minScale: PhotoViewComputedScale.contained,),
            ),
          );
        },
      ),
    );
  }
}
