import 'package:faithstream/model/blog.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleSearchPost extends StatelessWidget {
  Blog blog;
  String userToken;
  String memberId;

  SingleSearchPost(this.blog,this.userToken,this.memberId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(blog.title,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black87, fontSize: 18)),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (cntx, constraints) {
        return SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.02,
                    vertical: constraints.maxHeight * 0.01),
                width: constraints.maxWidth * 1,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AuthorInfo(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId),constraints,memberId,userToken,Provider
                          .of<BlogProvider>(context)
                          .searchBlogs[Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId)],isSingleChannel: false,),
                      blog.postType == "Image" ? ImagePostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId),
                          constraints, userToken, memberId) : blog.postType == "Video"
                          ? VideoPostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId),
                          constraints, userToken, memberId)
                          : Provider
                          .of<BlogProvider>(context)
                          .searchBlogs[Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId)]
                          .videoUrl == null ? EventImagePostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId),
                          constraints, memberId, userToken) : EventVideoPostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == blog.postId),
                          constraints, memberId, userToken),
                      /* ------------------- Like Share Comment -------------------------- */
                      Align(
                        alignment: Alignment.centerLeft,
                        child: LikeShareComment(Provider
                            .of<BlogProvider>(context)
                            .searchBlogs,Provider
                            .of<BlogProvider>(context)
                            .searchBlogs
                            .indexWhere((element) => element.postId == blog.postId),constraints,memberId,userToken,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          ,
        );
      },),
    );
  }

}