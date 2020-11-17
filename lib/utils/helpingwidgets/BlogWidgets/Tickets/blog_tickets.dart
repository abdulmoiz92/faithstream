import 'dart:convert';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class BuyTicketsUI extends StatefulWidget {
  String userToken;
  Blog blog;

  BuyTicketsUI(this.userToken, this.blog);

  @override
  _BuyTicketsUIState createState() => _BuyTicketsUIState();
}

class _BuyTicketsUIState extends State<BuyTicketsUI> {
  int Quantity = 1;
  double price;
  double discountPrice;
  int total;
  int discount = 0;
  int payable;
  int remainingTickets;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return FutureBuilder(
          future: _memoizer.runOnce(() => this.getData()),
          builder: (cntex, snapshots) {
            if (snapshots.connectionState == ConnectionState.done) {
              if (snapshots.data['status'] != "error") {
                price = double.parse(
                    snapshots.data['data']['ticketPrice'].toString());
                discountPrice = double.parse(
                    snapshots.data['data']['ticketDiscount'].toString());
                remainingTickets =
                    snapshots.data['data']['remainingTickets'] - Quantity;
                total = (price * Quantity).toInt();
                payable = total - discount;
              }
            }
            if (snapshots.connectionState == ConnectionState.done)
              if (snapshots.data['status'] == "error")
                return Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.cloud_off, size: 50, color: Colors.red,),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Text("Tickets Are Unavailable",
                      style: TextStyle(color: Colors.black87, fontSize: 15),),
                    SizedBox(height: constraints.maxHeight * 0.01),
                    Text("Please Check Later",
                      style: TextStyle(color: Colors.black45, fontSize: 15),)
                  ],);
            if (snapshots.connectionState == ConnectionState.waiting ||
                snapshots.connectionState == ConnectionState.done)
              switch (snapshots.connectionState) {
                case ConnectionState.done :
                  return snapshots.data['data']['remainingTickets'] == 0
                      ? Center(child: Image.asset("assets/images/soldout.jpg"),)
                      : Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              buildTextWithIcon(
                                  context,
                                  Icons.shopping_cart,
                                  "Buy Tickets",
                                  6.0,
                                  Colors.black87),
                              Spacer(),
                              IconButton(icon: Icon(Icons.clear, size: 15),
                                onPressed: () {
                                  Navigator.pop(context);
                                },)
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.03,
                              left: constraints.maxWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Price: Rs $price",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              Text(
                                "Buy ${snapshots
                                    .data['data']['ticketDiscountOnQty']} tickets & get discount of Rs ${snapshots
                                    .data['data']['ticketDiscount']} on each !",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.06),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Available Tickets: $remainingTickets",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.05,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.8,
                                child: double.parse(snapshots.data['data']
                                ['ticketsLimitPerPerson']
                                    .toString()) <=
                                    4 || snapshots
                                    .data['data']['remainingTickets'] <= 4
                                    ? Container(
                                  width: constraints.maxWidth * 0.7,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildNumber("1", snapshots.data['data']
                                      ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 1)
                                        buildNumber("2", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 2)
                                        buildNumber("3", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 3)
                                        buildNumber("4", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                    ],
                                  ),
                                )
                                    : SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor: Colors.white,
                                    activeTrackColor: Colors.white,
                                    overlayColor: Colors.white,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 7.0),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 15.0),
                                  ),
                                  child: Slider(
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.grey,
                                    value: Quantity.toDouble(),
                                    min: 1.0,
                                    // snapshots.data['data']['event']['ticketsLimitPerPerson'] > snapshots.data['data']['event']['remainingTickets'] ? double.parse(snapshots.data['data']['event']['remainingTickets'].toString()) :
                                    max: double.parse(snapshots
                                        .data['data']['ticketsLimitPerPerson']
                                        .toString()) > double.parse(snapshots
                                        .data['data']['remainingTickets']
                                        .toString()) ? double.parse(snapshots
                                        .data['data']['remainingTickets']
                                        .toString()) : double.parse(snapshots
                                        .data['data']['ticketsLimitPerPerson']
                                        .toString()),
                                    onChanged: (double newValue) {
                                      setState(() {
                                        Quantity = newValue.toInt();
                                        total =
                                            (Quantity * price).toInt();
                                        Quantity >=
                                            snapshots.data['data']
                                            ['ticketDiscountOnQty']
                                            ? discount =
                                            (discountPrice * Quantity)
                                                .toInt()
                                            : discount = 0;
                                        payable = total - discount;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: constraints.maxWidth * 0.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      buildInfoSingle("Quantity:", "$Quantity"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Sub Total:", "$total"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Discount:", "$discount"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Payable:", "$payable"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.1),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      if (payable != 0) {
                                        Navigator.pop(context);
/*                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: false,
                                            builder: (cntx) =>
                                                PaymentMehodModal(double.parse(
                                                    payable.toString())));*/
                                      }
                                    },
                                    child: Container(
                                      width: constraints.maxWidth * 0.2,
                                      margin: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.025,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                          color: payable == 0 ? Colors.red
                                              .withOpacity(0.4) : Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(25)),
                                      child: Text(
                                        "Next",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting :
                  return Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  );
                  break;
              }
          },
        );
      },
    );
  }

  Widget buildNumber(String text, maxDiscountQuantity, double discountPrice) {
    return GestureDetector(
      onTap: () {
        print(maxDiscountQuantity);
        setState(() {
          Quantity = int.parse(text);
          if (Quantity >= maxDiscountQuantity)
            discount = (discountPrice * Quantity).toInt();
          if (Quantity < maxDiscountQuantity)
            discount = 0;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Quantity == int.parse(text) ? Colors.red : Colors
                .transparent,
            border: Border.all(width: 1,
                color: Quantity == int.parse(text) ? Colors.transparent : Colors
                    .red),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(child: Text(text, style: TextStyle(
            color: Quantity == int.parse(text) ? Colors.white : Colors
                .black),)),
      ),
    );
  }

  void getData() async {
    var postData = await http.get(
        "$baseAddress/api/Member/GetEventByID/${widget.blog
            .eventId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});

    return json.decode(postData.body);
  }

  Widget buildInfoSingle(String heading, String amount) {
    return Row(
      children: <Widget>[
        Text(heading, style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        Text(amount),
      ],
    );
  }
}

