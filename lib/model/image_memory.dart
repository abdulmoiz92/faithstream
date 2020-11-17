import 'dart:typed_data';

class ImageMemory {
  String postId;
  String memoryImage;

  ImageMemory({this.postId,this.memoryImage});

  Map<String, dynamic> toMap() {
    return {
      'id': postId,
      'image': memoryImage,
    };
  }
}