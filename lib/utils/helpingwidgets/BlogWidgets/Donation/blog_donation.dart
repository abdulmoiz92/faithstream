import 'package:faithstream/model/donation.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Payment/post_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import '../../../shared_pref_helper.dart';

class DonationModalSingle extends StatefulWidget {
  String channelName;
  String postType;
  String postTitle;
  int channelId;
  String contentId;

  DonationModalSingle(
      {this.channelName,
      this.postType,
      this.postTitle,
      this.channelId,
      this.contentId});

  @override
  _DonationModalSingleState createState() => _DonationModalSingleState();
}

class _DonationModalSingleState extends State<DonationModalSingle> {
  TextEditingController amountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: constraints.maxWidth * 0.85,
                      child: TextField(
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        controller: amountController,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Add Your Amount",
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          if (amountController.text != "") {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                builder: (cntx) => PaymentMehodModal(
                                      amount:
                                          double.parse(amountController.text),
                                      notes:
                                          "You Donated to a ${widget.postType} by ${widget.channelName} with Title ${widget.postTitle}",
                                      channelId: widget.channelId,
                                      postType: widget.postType,
                                      contentId: widget.contentId,
                                    ));
                          }
                        },
                        child: Icon(
                          Icons.monetization_on,
                          color: amountController.text.isEmpty
                              ? Colors.red.withOpacity(0.3)
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                )),
          );
          ;
        },
      ),
    );
  }
}

class DonationModal extends StatefulWidget {
  List<Donation> donationsList;
  String channelName;
  String postType;
  String postTitle;
  int channelId;
  String contentId;

  DonationModal(this.donationsList,
      {this.channelName,
      this.postType,
      this.postTitle,
      this.channelId,
      this.contentId});

  @override
  _DonationModalState createState() => _DonationModalState();
}

class _DonationModalState extends State<DonationModal> {
  double amount = 0.0;
  TextEditingController amountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.clear, size: 15),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.9,
                    child: ListView.builder(
                        itemCount: widget.donationsList.length + 2,
                        itemBuilder: (cntx, index) {
                          return StatefulBuilder(
                            builder: (cntx, _setState) {
                              return Container(
                                margin:
                                    EdgeInsets.only(top: index == 0 ? 0 : 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    if (index < widget.donationsList.length)
                                      RadioListTile(
                                        activeColor: Colors.red,
                                        groupValue: amount,
                                        value: double.parse(
                                          widget
                                              .donationsList[index].denomAmount,
                                        ),
                                        title: Container(
                                          width: constraints.maxWidth * 0.75,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 16),
                                          color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Suggested",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.62,
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text(
                                                      "${widget.donationsList[index].denomDescription == null || widget.donationsList[index].denomDescription.isEmpty ? "" : widget.donationsList[index].denomDescription}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Text(
                                                  "\$${widget.donationsList[index].denomAmount}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        onChanged: handleRadioChange,
                                      ),
                                    if (index == widget.donationsList.length)
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: RadioListTile(
                                          activeColor: Colors.red,
                                          groupValue: amount,
                                          value: amountController.text == ""
                                              ? 0.0
                                              : double.parse(
                                                  amountController.text),
                                          title: TextField(
                                            controller: amountController,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false,
                                                    signed: false),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              labelText: "Enter Amount Here",
                                              labelStyle: TextStyle(
                                                  color: Color(0xFAC9CAD1)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFEBEAEF)),
                                              ),
                                            ),
                                          ),
                                          onChanged: handleRadioChange,
                                        ),
                                      ),
                                    if (index ==
                                        widget.donationsList.length + 1)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (amount != 0.0) {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  builder: (cntx) =>
                                                      PaymentMehodModal(
                                                        amount: amount,
                                                        notes:
                                                            "You Donated to a ${widget.postType} by ${widget.channelName} with Title ${widget.postTitle}",
                                                        channelId:
                                                            widget.channelId,
                                                        postType:
                                                            widget.postType,
                                                        contentId:
                                                            widget.contentId,
                                                      ));
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    constraints.maxWidth * 0.04,
                                                bottom: constraints.maxHeight *
                                                    0.05),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 6.0),
                                            decoration: BoxDecoration(
                                                color: amount == 0.0
                                                    ? Colors.red
                                                        .withOpacity(0.3)
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Text(
                                              "Donate",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void handleRadioChange(double value) {
    setState(() {
      amount = value;
    });
  }
}

class SendDonationPaymentRequest extends StatefulWidget {
  String amount;
  String cardType;
  String cardNumber;
  int channelId;
  String cvc;
  String expiryMonth;
  String expiryYear;
  String notes;
  String postType;
  String contentId;

  SendDonationPaymentRequest(
      {this.amount,
      this.cardType,
      this.cardNumber,
      this.cvc,
      this.expiryMonth,
      this.expiryYear,
      this.notes,
      this.channelId,
      this.postType,
      this.contentId});

  @override
  _SendDonationPaymentRequestState createState() =>
      _SendDonationPaymentRequestState();
}

class _SendDonationPaymentRequestState
    extends State<SendDonationPaymentRequest> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memoizer.runOnce(() => makePaymentOfDonation(
          context: context,
          contentId: widget.contentId,
          notes: widget.notes,
          postType: widget.postType,
          channelId: widget.channelId,
          amount: widget.amount,
          cardType: widget.cardType,
          cardNumber: widget.cardNumber,
          cvc: widget.cvc,
          expiryMonth: widget.expiryMonth,
          expiryYear: widget.expiryYear)),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("Please Wait..."),
                  )
                ],
              ),
            );
            break;
          case ConnectionState.done:
            return snapshot.data == true
                ? Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0, top: 4.0),
                          child: IconButton(
                            icon: Icon(Icons.clear, size: 15),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              color: Colors.red,
                              size: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text("Done"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0, top: 4.0),
                          child: IconButton(
                            icon: Icon(Icons.clear, size: 15),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text("Something Went Wrong :("),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
        }
      },
    );
    ;

    /**/
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    setState(() {
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
  }
}
