import 'package:faithstream/model/blog.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Donation/blog_donation.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/EventFollow/event_follow.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Tickets/blog_tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonateRemindBuy extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  BoxConstraints constraints;
  String userToken;
  String memberId;
  bool isEvent;

  DonateRemindBuy(
      {this.isEvent,
      this.allBlogs,
      this.index,
      this.constraints,
      this.userToken,
      this.memberId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (allBlogs[index].isPast != true && isEvent == true)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.27,
            child: buildIconText(
                context, "Remind Me", Icons.notifications, 3.0, Colors.white,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (cntx) => EventFollowModal(constraints,
                          allBlogs[index].eventId, int.parse(memberId), userToken));
                }),
          ),
        if (allBlogs[index].isPast != true && isEvent == true) Spacer(),
        if (allBlogs[index].isDonationRequired == true)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.22,
            child: buildIconText(
                context, "Donate", Icons.monetization_on, 3.0, Colors.white,
                onTap: () {
                  allBlogs[index].donations.length == 0
                      ? showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      builder: (cntx) => DonationModalSingle(
                        channelName: allBlogs[index].author,
                        postTitle: allBlogs[index].title,
                        postType: allBlogs[index].postType,
                        channelId: allBlogs[index].authorId,
                        contentId: allBlogs[index].postId,
                      ))
                      : showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      builder: (cntx) => Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: DonationModal(
                          allBlogs[index].donations,
                          contentId: allBlogs[index].postId,
                          postType: allBlogs[index].postType,
                          channelId: allBlogs[index].authorId,
                          postTitle: allBlogs[index].title,
                          channelName: allBlogs[index].author,
                        ),
                      ));
                }),
          ),
        if (allBlogs[index].isPast != true && isEvent == true ||
            allBlogs[index].isDonationRequired == true &&
                allBlogs[index].isTicketAvailable == true)
          Spacer(),
        if (allBlogs[index].isTicketAvailable ==
            true /* && widget.allBlogs[widget.index].isPast != true */)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.27,
            child: buildIconText(
                context, "Buy Tickets", Icons.loyalty, 3.0, Colors.white,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      isScrollControlled: true,
                      builder: (cntx) => Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          margin: EdgeInsets.only(top: 20),
                          child: BuyTicketsUI(userToken, allBlogs[index])));
                }),
          ),
      ],
    );
  }
}

class DetailsTextField extends StatelessWidget {
  String labelText;
  IconData icon;
  TextEditingController controller;
  List<TextInputFormatter> inputList;
  Function onChange;

  DetailsTextField(
      {this.labelText,
      this.icon,
      this.controller,
      this.inputList,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: inputList,
      onChanged: onChange,
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10, right: 10),
        labelText: labelText,
        suffixIcon: icon == null
            ? null
            : Icon(
                icon,
                color: Colors.red,
              ),
        labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEBEAEF)),
        ),
      ),
    );
  }
}
