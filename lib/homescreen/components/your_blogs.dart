import 'dart:ui';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourBlogs extends StatelessWidget {
  final List<Blog> allBlogs;

  YourBlogs(@required this.allBlogs);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      return allBlogs == null
          ? Text("No Blogs To Show")
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allBlogs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (cntx) => SingleBlogPost(
                                        singleBlog: allBlogs[index],
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right: constraints.maxWidth * 0.04),
                          width: constraints.maxWidth * 0.7,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                image: DecorationImage(
                                    image: allBlogs[index].image == null
                                        ? AssetImage("assets/images/laptop.png")
                                        : NetworkImage(allBlogs[index].image),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.35),
                                        BlendMode.darken)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: <Widget>[
/*                      Image.asset("assets/images/loginbg.png",
                              fit: BoxFit.cover, width: constraints.maxWidth, height: constraints.maxHeight * 0.6)*/
                                    SizedBox(
                                      height: constraints.maxHeight * 0.04,
                                    ),
                                    Flexible(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 15),
                                          width: constraints.maxWidth * 0.9,
                                          child: Container(
                                            height:
                                                constraints.maxHeight * 0.68,
                                            child: Text(
                                              allBlogs[index].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize:
                                                      (constraints.maxHeight *
                                                              0.3) /
                                                          4,
                                                  color: Colors.white,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: constraints.maxHeight * 0.32,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: buildAvatarText(
                                        context,
                                        allBlogs[index].authorImage,
                                        allBlogs[index].author,
                                        constraints.maxHeight * 0.01,
                                        buildIconText(
                                            context,
                                            allBlogs[index].time,
                                            Icons.watch_later,
                                            2.0,
                                            Colors.white),
                                        buildIconText(
                                            context,
                                            allBlogs[index].likes,
                                            Icons.thumb_up,
                                            2.0,
                                            Colors.white),
                                        Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              });
    });
  }
}
/*index == 4
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Column(
                                children: <Widget>[
                                  Icon(Icons.arrow_forward,color: Colors.white,),
                                  SizedBox(height: constraints.maxHeight * 0.01,),
                                ],
                              ),),
                            ),
                          ],
                        ),
                      )*/
