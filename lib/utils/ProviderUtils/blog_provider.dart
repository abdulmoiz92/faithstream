import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:flutter/cupertino.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> lazyBlog = [];
  List<Blog> allBlogs = [];
  List<Blog> favouriteTimeLine = [];
  List<TPost> trendingPosts = [];
  List<Comment> comments = [];
  List<Comment> trendingComments = [];
  List<Blog> singleChannelBlogs = [];
  List<Blog> searchBlogs = [];
  List<Channel> searchChannels = [];
 var appBarHeight = 0.0;

 void increaseItems(int previousLength,List<Blog> blogList) {
   for(var i = previousLength; i <= previousLength + 10; i++) {
     lazyBlog.add(blogList[i]);
     print("added");
     notifyListeners();
   }
 }

  set setAppBarHeight(double height) {
    appBarHeight = height;
    notifyListeners();
  }

  get getAppBarHeight => appBarHeight;

  set addBlog(Blog blog) {
    allBlogs.add(blog);
    notifyListeners();
  }

  bool postExistsInBlog(String id) {
   return allBlogs.indexWhere((element) => element.postId == id) == -1 ? false : true;
  }

  bool postExistsInSearchBlog(String id) {
    return searchBlogs.indexWhere((element) => element.postId == id) == -1 ? false : true;
  }

  bool postExistsInSingleChannelBlog(String id) {
    return singleChannelBlogs.indexWhere((element) => element.postId == id) == -1 ? false : true;
  }

  bool postExistsInFavouriteTimeline(String id) {
    return favouriteTimeLine.indexWhere((element) => element.postId == id) == -1 ? false : true;
  }

  set addTrendingPost(TPost tPost) {
    trendingPosts.add(tPost);
    notifyListeners();
  }

  int getIsPostFavourtite(String id) {
   if(postExistsInBlog(id))
   return allBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
   if(postExistsInSingleChannelBlog(id))
   return singleChannelBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
   if(postExistsInSearchBlog(id))
   return searchBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
   if(postExistsInFavouriteTimeline(id))
   return favouriteTimeLine.firstWhere((element) => element.postId == id).getIsFavourite;
  }

  int getIsSingleChannelPostFavourtie(String id) {
    return singleChannelBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
  }

  int getIsSearchPostFavourite(String id) {
    return searchBlogs.firstWhere((element) => element.postId == id).getIsFavourite;
  }

  int getIsFavouriteTimelinePostFavourite(String id) {
    return favouriteTimeLine.firstWhere((element) => element.postId == id).getIsFavourite;
  }

  set addSingleChannelBlogs(Blog blog) {
    singleChannelBlogs.add(blog);
    notifyListeners();
  }

  set addSearchBlog(Blog blog) {
    if(postExistsInSearchBlog(blog.postId) == false)
    searchBlogs.add(blog);
    notifyListeners();
  }

  void resetSearchBlog() {
    searchBlogs = [];
    notifyListeners();
  }

  set addChannelSearch(Channel channel) {
      searchChannels.add(channel);
    notifyListeners();
  }

  void resetChannelSearch() {
    searchChannels = [];
    notifyListeners();
  }

  set setIsPostFavourite(String id) {
    if(postExistsInBlog(id))
    allBlogs.firstWhere((element) => element.postId == id).setIsFavourite = allBlogs.firstWhere((element) => element.postId == id).getIsFavourite == 1 ? 0 : 1;
    if(postExistsInSingleChannelBlog(id))
    singleChannelBlogs.firstWhere((element) => element.postId == id).setIsFavourite = singleChannelBlogs.firstWhere((element) => element.postId == id).getIsFavourite == 1 ? 0 : 1;
    if(postExistsInSearchBlog(id))
    searchBlogs.firstWhere((element) => element.postId == id).setIsFavourite = searchBlogs.firstWhere((element) => element.postId == id).getIsFavourite == 1 ? 0 : 1;
    if(postExistsInFavouriteTimeline(id))
    favouriteTimeLine.firstWhere((element) => element.postId == id).setIsFavourite = favouriteTimeLine.firstWhere((element) => element.postId == id).getIsFavourite == 1 ? 0 : 1;
    notifyListeners();
  }

  int getIsPostLiked(String id) {
    if(postExistsInBlog(id))
    return allBlogs.firstWhere((element) => element.postId == id).getIsLiked;
    if(postExistsInSingleChannelBlog(id))
    return singleChannelBlogs.firstWhere((element) => element.postId == id).getIsLiked;
    if(postExistsInSearchBlog(id))
    return searchBlogs.firstWhere((element) => element.postId == id).getIsLiked;
    if(postExistsInFavouriteTimeline(id))
    return favouriteTimeLine.firstWhere((element) => element.postId == id).getIsLiked;
  }

  set setIsPostLiked(String id) {
    if(postExistsInBlog(id))
    allBlogs.firstWhere((element) => element.postId == id).setIsLiked = allBlogs.firstWhere((element) => element.postId == id).getIsLiked == 1 ? 0 : 1;
    if(postExistsInSingleChannelBlog(id))
    singleChannelBlogs.firstWhere((element) => element.postId == id).setIsLiked = singleChannelBlogs.firstWhere((element) => element.postId == id).getIsLiked == 1 ? 0 : 1;
    if(postExistsInSearchBlog(id))
    searchBlogs.firstWhere((element) => element.postId == id).setIsLiked = searchBlogs.firstWhere((element) => element.postId == id).getIsLiked == 1 ? 0 : 1;
    if(postExistsInFavouriteTimeline(id))
    favouriteTimeLine.firstWhere((element) => element.postId == id).setIsLiked = favouriteTimeLine.firstWhere((element) => element.postId == id).getIsLiked == 1 ? 0 : 1;
    notifyListeners();
  }

  get blogsLength => allBlogs.length;

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

  void addComment(Comment comment) {
    comments.add(comment);
    notifyListeners();
  }

  void resetComments() {
    comments = [];
    notifyListeners();
  }

  void removeComment(String commentId) {
    comments.removeWhere((element) => element.commentId == commentId);
    notifyListeners();
  }

  List<Comment> getCommentsList() {
   return comments;
  }

  void setCommentId(String tempId,String commentId) {
    comments.firstWhere((element) => element.temopraryId == tempId).commentId = commentId;
    notifyListeners();
  }

  int getCommentIndexByTempId(String tempId) {
    return comments.indexOf(comments.firstWhere((element) => element.temopraryId == tempId));
  }

  void resetTempId(String tempId) {
    comments.firstWhere((element) => element.temopraryId == tempId).temopraryId = null;
    notifyListeners();
  }


  void addTPostComment(Comment comment) {
    trendingComments.insert(0,comment);
    notifyListeners();
  }

  void resetTPostComments() {
    trendingComments = [];
    notifyListeners();
  }

  void removeTPostComment(String commentId) {
    trendingComments.removeWhere((element) => element.commentId == commentId);
    notifyListeners();
  }

  List<Comment> getTPostCommentsList() {
    return trendingComments;
  }

  void setTrendingCommentId(String tempId,String commentId) {
    trendingComments.firstWhere((element) => element.temopraryId == tempId).commentId = commentId;
    notifyListeners();
  }

  int getTrendingCommentIndexByTempId(String tempId) {
    return trendingComments.indexOf(trendingComments.firstWhere((element) => element.temopraryId == tempId));
  }

  void resetTrendingTempId(String tempId) {
    trendingComments.firstWhere((element) => element.temopraryId == tempId).temopraryId = null;
    notifyListeners();
  }

  List<Blog> getSingleChannelVideos() {
    return singleChannelBlogs.where((element) => element.postType == "Video").toList();
  }

  List<Blog> getSingleChannelEvents() {
    return singleChannelBlogs.where((element) => element.postType == "Event").toList();
  }

  void removeUnscribedChannelPosts(int id) {
    allBlogs.removeWhere((element) => element.authorId == id);
    notifyListeners();
  }

  void sortBlog() {
    allBlogs.sort((a,b) => a.date.compareTo(b.date));
    allBlogs = allBlogs.reversed.toList();
    notifyListeners();
  }

  void resetTrendingVideos() {
    trendingPosts = [];
    notifyListeners();
  }

  void resetSingleChannelBlogs() {
    singleChannelBlogs = [];
    notifyListeners();
  }
}