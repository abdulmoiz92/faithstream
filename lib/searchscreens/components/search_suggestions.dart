import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/searchscreens/components/single_searchpost.dart';
import 'package:faithstream/singlepost/single_channel.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;
import 'package:flutter/material.dart';

class SearchSuggestions extends StatefulWidget {
  List<Blog> searchResults;
  List<Channel> channelSearchResults;
  List<TPost> trendingSearchResults;
  String userToken;
  String memberId;
  String profileImage;
  FocusNode searchFocusNode;

  SearchSuggestions(
      {this.searchResults,
      this.channelSearchResults,
      this.trendingSearchResults,
      this.userToken,
      this.memberId,this.profileImage,this.searchFocusNode});

  @override
  _SearchSuggestionsState createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  int itemsLengh = 0;
  String title = "";

  @override
  Widget build(BuildContext context) {
    if (widget.searchResults != null)
      setState(() {
        itemsLengh =
            widget.searchResults.length > 10 ? 10 : widget.searchResults.length;
      });
    if (widget.trendingSearchResults != null)
      setState(() {
        itemsLengh = widget.trendingSearchResults.length > 10
            ? 10
            : widget.trendingSearchResults.length;
      });
    if (widget.channelSearchResults != null)
      setState(() {
        itemsLengh = widget.channelSearchResults.length > 10
            ? 10
            : widget.channelSearchResults.length;
      });
    return LayoutBuilder(builder: (cntes,constraints) {
      return ListView.separated(
          itemCount: itemsLengh,
          separatorBuilder: (cntx, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
          ),
          itemBuilder: (cntx, index) {
            if (widget.searchResults != null)
              title = widget.searchResults[index].title;
            if (widget.trendingSearchResults != null)
              title = widget.trendingSearchResults[index].title;
            if (widget.channelSearchResults != null)
              title = widget.channelSearchResults[index].channelName;
            return Center(
              child: Container(
                width: double.infinity,
                child: ListTile(
                  onTap: () {
                    widget.searchFocusNode.unfocus();
                    if (widget.searchResults != null)
                      bs.showModalBottomSheet(context: context, builder: (cntx) => SingleSearchPost(
                          widget.searchResults[index],
                          widget.userToken,
                          widget.memberId,widget.profileImage),barrierColor: Colors.white.withOpacity(0),isDismissible: false,enableDrag: false,isScrollControlled: true);
                    if (widget.trendingSearchResults != null)
                      bs.showModalBottomSheet(context: context, builder: (cntx) => SingleBlogPost(
                          singleBlog: null,
                          trendingPost:
                          widget.trendingSearchResults[index]),isScrollControlled: true,enableDrag: false,isDismissible: false,barrierColor: Colors.white.withOpacity(0));
                    if (widget.channelSearchResults != null)
                      bs.showModalBottomSheet(context: context, builder: (cntx) => SingleChannel(
                          widget.channelSearchResults[index].id),barrierColor: Colors.white.withOpacity(0),isDismissible: false,enableDrag: false,isScrollControlled: true);
                  },
                  leading: Container(
                    width: constraints.maxWidth * 0.8,
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  trailing: Icon(Icons.trending_up),
                ),
              ),
            );
          });
    },);
  }
}
