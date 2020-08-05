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
            return Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 12.0, top: 8.0),
                padding: EdgeInsets.all(8.0),
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: widget.scrollingList[index].authorImage ==
                                      null
                                  ? AssetImage("assets/images/test.jpeg")
                                  : NetworkImage(
                                      widget.scrollingList[index].authorImage),
                              fit: BoxFit.fill)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.scrollingList[index].authorName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.only(top: 4.0),
                            width: constraints.maxWidth * 0.55,
                            child: Text(
                              widget.scrollingList[index].commentText,
                              style: TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          buildIconText(
                              context,
                              widget.scrollingList[index].time,
                              Icons.calendar_today,
                              3.0,
                              Colors.black),
                          if (widget.memberId ==
                              widget.scrollingList[index].commentMemberId
                                  .toString())
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                  onTap: () {
                                      deleteComment(
                                          context,
                                          widget.postId,
                                          widget.scrollingList[index].commentId,
                                          widget.userToken);
                                  },
                                  child: Text(
                                    "Delete",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 10),
                                  )),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  }
