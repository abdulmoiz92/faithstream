import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalBottom extends StatelessWidget {
  final List<Comment> scrollingList;

  ModalBottom({this.scrollingList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return ListView.builder(
          itemCount: scrollingList.length,
          itemBuilder: (cntx, index) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 12.0,top: 8.0),
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
                              image: AssetImage("assets/images/test.jpeg"),
                              fit: BoxFit.fill)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(scrollingList[index].authorName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(scrollingList[index].commentText),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 5.0),
                      child: buildIconText(context, scrollingList[index].time, Icons.calendar_today, 3.0, Colors.black),
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
