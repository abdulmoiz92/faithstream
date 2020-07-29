import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/utils/databasemethods/database_methods.dart';
import 'package:flutter/cupertino.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> allBlogs = [];
  List<Blog> favouriteTimeLine = [];

  set addBlog(Blog blog) {
    allBlogs.add(blog);
    notifyListeners();
  }

  int getIsPostFavourtite(String id) {
   return allBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
  }

  set setIsPostFavourite(String id) {
    allBlogs.firstWhere((element) => element.postId == id).setIsFavourite = allBlogs.firstWhere((element) => element.postId == id).getIsFavourite == 1 ? 0 : 1;
    notifyListeners();
  }

  int getIsPostLiked(String id) {
    return allBlogs.firstWhere((element) => element.postId == id).getIsLiked;
  }

  set setIsPostLiked(String id) {
    allBlogs.firstWhere((element) => element.postId == id).setIsLiked = allBlogs.firstWhere((element) => element.postId == id).getIsLiked == 1 ? 0 : 1;
    notifyListeners();
  }

  get getAllBlogs => allBlogs;

  set addFavouriteTimeLine(Blog blog) {
    favouriteTimeLine.add(blog);
    notifyListeners();
  }

  set resetFavourite(List<Blog> blogs) {
    favouriteTimeLine = blogs;
    notifyListeners();
  }

  get getFavouriteTimeLine => favouriteTimeLine;

  void addComment(Comment comment,String id) {
    allBlogs.firstWhere((element) => element.postId == id).comments.add(comment);
    notifyListeners();
  }

  void resetComments(String id) {
    allBlogs.firstWhere((element) => element.postId == id).comments = [];
    notifyListeners();
  }

  void removeComment(String postId,String commentId) {
    allBlogs.firstWhere((element) => element.postId == postId).comments.removeWhere((element) => element.commentId == commentId);
    notifyListeners();
  }

  List<Comment> getCommentsList(String id) {
   return allBlogs.firstWhere((element) => element.postId == id).comments;
  }
}