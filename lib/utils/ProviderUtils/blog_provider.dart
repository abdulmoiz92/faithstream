import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:flutter/cupertino.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> allBlogs = [];
  List<Blog> favouriteTimeLine = [];
  List<TPost> trendingPosts = [];

  set addBlog(Blog blog) {
    allBlogs.add(blog);
    notifyListeners();
  }

  set addTrendingPost(TPost tPost) {
    trendingPosts.add(tPost);
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

  get getAllTPosts => trendingPosts;

  set addFavouriteTimeLine(Blog blog) {
    favouriteTimeLine.add(blog);
    notifyListeners();
  }

  set resetFavourite(List<Blog> blogs) {
    favouriteTimeLine = blogs;
    notifyListeners();
  }

  set resetBlog(List<Blog> blogs) {
    allBlogs = blogs;
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



  void addTPostComment(Comment comment,String id) {
    trendingPosts.firstWhere((element) => element.videoId == id).videoComments.insert(0, comment);
    notifyListeners();
  }

  void resetTPostComments(String id) {
    trendingPosts.firstWhere((element) => element.videoId == id).videoComments = [];
    notifyListeners();
  }

  void removeTPostComment(String postId,String commentId) {
    trendingPosts.firstWhere((element) => element.videoId == postId).videoComments.removeWhere((element) => element.commentId == commentId);
    notifyListeners();
  }

  List<Comment> getTPostCommentsList(String id) {
    return trendingPosts.firstWhere((element) => element.videoId == id).videoComments;
  }
}