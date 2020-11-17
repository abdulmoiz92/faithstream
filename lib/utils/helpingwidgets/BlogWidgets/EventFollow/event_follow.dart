import 'package:faithstream/profile/event_followed.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';

class EventFollowModal extends StatelessWidget {
  final BoxConstraints constraints;
  final int eventId;
  final int memberId;
  final String userToken;

  bool reminder1 = false;

  bool reminder2 = false;

  bool reminder3 = false;


  EventFollowModal(this.constraints, this.eventId, this.memberId,
      this.userToken);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: StatefulBuilder(builder: (context, _setState) {
        return Column(
          children: <Widget>[
            CheckboxListTile(value: reminder1,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("15 Minutes Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder1 = newValue;
                  });
                }),
            CheckboxListTile(value: reminder2,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("1 Hour Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder2 = newValue;
                  });
                }),
            CheckboxListTile(value: reminder3,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("1 Day Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder3 = newValue;
                  });
                }),
            Align(alignment: Alignment.bottomRight,
              child: Container(decoration: BoxDecoration(
                  color: reminder1 || reminder2 || reminder3
                      ? Colors.red
                      : Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25)),
                margin: EdgeInsets.only(top: 16.0),
                width: constraints.maxWidth * 0.2,
                child: GestureDetector(
                  onTap: () {
                    if (reminder1 || reminder2 || reminder3) {
                      addEventFollow(context, eventId, memberId, userToken,
                          reminder1: reminder1,
                          reminder2: reminder2,
                          reminder3: reminder3).then((_) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (cntx) => EventsFollowed()));
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0),
                    child: Center(child: Text("Done", style: TextStyle(
                        color: Colors.white),)),
                  ),
                ),),),
          ],
        );
      },),
    );
  }
}