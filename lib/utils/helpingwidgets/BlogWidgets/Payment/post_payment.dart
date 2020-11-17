import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Donation/blog_donation.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Helpers/blog_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentMehodModal extends StatefulWidget {
  double amount;
  int channelId;
  String notes;
  String contentId;
  String postType;

  PaymentMehodModal(
      {this.amount, this.notes, this.channelId, this.contentId, this.postType});

  @override
  _PaymentMehodModalState createState() => _PaymentMehodModalState();
}

class _PaymentMehodModalState extends State<PaymentMehodModal> {
  int method = 0;

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
                      icon: Icon(
                        Icons.clear,
                        size: 15,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: RadioListTile(
                      activeColor: Colors.red,
                      onChanged: handleRadioChange,
                      groupValue: method,
                      value: 1,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.credit_card,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "Pay With Paypal",
                              style: TextStyle(color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (method != 0) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (cntxs) => Container(
                              height: MediaQuery.of(cntxs).size.height * 0.7,
                              child: PaypalDetails(
                                amount: widget.amount.toString(),
                                channelId: widget.channelId,
                                notes: widget.notes,
                                contentId: widget.contentId,
                                postType: widget.postType,
                              )));
                    }
                  },
                  child: Container(
                    width: constraints.maxWidth * 0.2,
                    margin: EdgeInsets.only(
                        right: constraints.maxWidth * 0.04,
                        bottom: constraints.maxHeight * 0.05),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                        color: method == 0
                            ? Colors.red.withOpacity(0.3)
                            : Colors.red,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void handleRadioChange(int value) {
    setState(() {
      method = value;
    });
  }
}

class PaypalDetails extends StatefulWidget {
  String amount;
  int channelId;
  String notes;
  String contentId;
  String postType;

  PaypalDetails(
      {this.amount, this.notes, this.contentId, this.channelId, this.postType});

  @override
  _PaypalDetailsState createState() => _PaypalDetailsState();
}

class _PaypalDetailsState extends State<PaypalDetails> {
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController expirationDayController = new TextEditingController();
  TextEditingController expirationMonthController = new TextEditingController();
  TextEditingController cvvController = new TextEditingController();

  String cardNumberText = "";
  String expirationDayText = "";
  String expirationMonthText = "";
  String cvvText = "";

  @override
  Widget build(BuildContext context) {
    /* ------------------- Validations -------------------- */
    bool validation = cardNumberText.isNotEmpty &&
        expirationDayText.isNotEmpty &&
        expirationMonthText.isNotEmpty &&
        cvvText.isNotEmpty;
    bool lengthValidation = cardNumberController.text.length == 16 &&
        expirationDayText.length == 2 &&
        expirationMonthText.length == 4 &&
        cvvText.length == 3;
    String cardType = getCardType(cardNumberText);
    bool expirationValidation = false;
    if (validation == true)
      expirationValidation = (int.parse(expirationMonthController.text) ==
                  DateTime.now().year &&
              int.parse(expirationDayController.text) > DateTime.now().month &&
              int.parse(expirationDayController.text) != 0 &&
              int.parse(expirationDayController.text) <= 12) ||
          (int.parse(expirationMonthController.text) > DateTime.now().year &&
              int.parse(expirationMonthController.text) <=
                  (DateTime.now().year + 3) &&
              int.parse(expirationDayController.text) != 0 &&
              int.parse(expirationDayController.text) <= 12);
    print(
        "validation: $validation  Expiration $expirationValidation  Length: $lengthValidation");
    /* ------------------- End Validations -------------------- */
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
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
                padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.085, horizontal: 8.0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Card Number",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        Spacer(),
                        if (cardType != null)
                          Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                cardType == "visa"
                                    ? "assets/images/visa.png"
                                    : "assets/images/mastercard.png",
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              )),
                        if (cardType == null)
                          Text(
                              cardNumberController.text.isNotEmpty
                                  ? "Not Supported"
                                  : "",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    DetailsTextField(
                      labelText: "xxxx xxxx xxxx xxxx",
                      controller: cardNumberController,
                      inputList: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16)
                      ],
                      onChange: (value) {
                        setState(() {
                          cardNumberText = value;
                        });
                      },
                      icon: Icons.credit_card,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Text(
                      "Expiration Date",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: DetailsTextField(
                              labelText: "MM",
                              controller: expirationDayController,
                              inputList: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2)
                              ],
                              onChange: (value) {
                                setState(() {
                                  expirationDayText = value;
                                });
                              },
                            )),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: DetailsTextField(
                              labelText: "YYYY",
                              controller: expirationMonthController,
                              inputList: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4)
                              ],
                              onChange: (value) {
                                setState(() {
                                  expirationMonthText = value;
                                });
                              },
                            )),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Text(
                      "CVV",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    DetailsTextField(
                      labelText: "xxx",
                      controller: cvvController,
                      inputList: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      onChange: (value) {
                        setState(() {
                          cvvText = value;
                        });
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          if (validation && lengthValidation) {
                            if (expirationValidation && cardType != null) {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  builder: (cntxs) => Container(
                                      height: MediaQuery.of(cntxs).size.height *
                                          0.7,
                                      child: SendDonationPaymentRequest(
                                        amount: widget.amount,
                                        channelId: widget.channelId,
                                        notes: widget.notes,
                                        cardNumber: cardNumberText,
                                        cardType: cardType,
                                        cvc: cvvText,
                                        expiryMonth: expirationDayText,
                                        expiryYear: expirationMonthText,
                                        contentId: widget.contentId,
                                        postType: widget.postType,
                                      )));
                            }
                          }
                        },
                        child: Container(
                          width: constraints.maxWidth * 0.2,
                          margin: EdgeInsets.only(
                              right: constraints.maxWidth * 0.04,
                              bottom: constraints.maxHeight * 0.05),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          decoration: BoxDecoration(
                              color: validation == false ||
                                      expirationValidation == false ||
                                      lengthValidation == false ||
                                      cardType == null
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            "Done",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
      },
    );
  }

  String getCardType(String number) {
    if (number.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      return "master";
    } else if (number.startsWith(new RegExp(r'[4]'))) {
      return "visa";
    } else {
      return null;
    }
  }
}
