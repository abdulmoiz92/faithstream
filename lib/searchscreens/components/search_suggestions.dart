import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/searchscreens/components/single_searchpost.dart';
import 'package:faithstream/singlepost/single_channel.dart';
import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  List<Blog> searchResults;
  List<Channel> channelSearchResults;
  String userToken;
  String memberId;

  SearchSuggestions({this.searchResults,this.channelSearchResults,this.userToken,this.memberId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: searchResults == null ? channelSearchResults.length > 10 ? 10 : channelSearchResults.length : searchResults.length > 10 ? 10 : searchResults.length,
        separatorBuilder: (cntx, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
            ),
        itemBuilder: (cntx, index) {
          return Center(
            child: Container(
              width: double.infinity,
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (cntx) => searchResults != null ? SingleSearchPost(searchResults[index], userToken, memberId) : SingleChannel(channelSearchResults[index].id)));
                },
                leading: Text(
                 searchResults != null ? searchResults[index].title : channelSearchResults[index].channelName,
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                trailing: Icon(Icons.trending_up),
              ),
            ),
          );
        });
  }
}
