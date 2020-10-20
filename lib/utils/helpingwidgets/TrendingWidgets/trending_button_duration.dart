import 'package:flutter/material.dart';

class ButtonAndDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(8.0),
            height: 20,
            child: Text("0:38", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
