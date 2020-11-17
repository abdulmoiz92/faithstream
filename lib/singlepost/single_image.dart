import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:async/async.dart';

class SingleImage extends StatefulWidget {
  String imageUrl;
  Uint8List imageBytes;

  SingleImage(this.imageUrl,this.imageBytes);

  @override
  _SingleImageState createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  MemoryImage memoryImage;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    if(widget.imageBytes != null)
    _memoizer.runOnce(() => preCacheTheImage(context));
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Center(
            child: Container(
              width: double.infinity,
              height: constraints.maxHeight * 1,
              child: PhotoView(imageProvider: widget.imageBytes == null ? NetworkImage(widget.imageUrl) : memoryImage,filterQuality: FilterQuality.high,minScale: PhotoViewComputedScale.contained,),
            ),
          );
        },
      ),
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = MemoryImage(widget.imageBytes);
    precacheImage(memoryImage,context);
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
