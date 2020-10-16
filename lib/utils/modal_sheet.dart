import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalBottom extends StatefulWidget {
  final List<Comment> scrollingList;
  final String userToken;
  final String postId;
  final String memberId;

  ModalBottom({this.scrollingList, this.userToken, this.postId, this.memberId});

  void addCommentToList(Comment comment) {
    scrollingList.add(comment);
  }

  @override
  _ModalBottomState createState() => _ModalBottomState();
}

class _ModalBottomState extends State<ModalBottom> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return ListView.builder(
          itemCount: widget.scrollingList.length,
          itemBuilder: (cntx, index) {
            return SingleCommentDesign(memberId: widget.memberId,userToken: widget.userToken,constraints: constraints,postId: widget.postId,comment: widget.scrollingList[index],);
          },
        );
      },
    );
  }
  }
