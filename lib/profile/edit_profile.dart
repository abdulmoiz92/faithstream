import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  String userToken;
  String memberId;
  String userId;
  String image;
  String firstName;
  String lastName;
  String userEmail;
  String userPhone;

  EditProfile(
      {@required this.userToken, @required this.memberId, @required this.userId, @required this.image, @required this.firstName, @required this.lastName, @required this.userEmail, @required this.userPhone});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        "Edit Profile",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black87, fontSize: 18),
      ),
      backgroundColor: Colors.white,
    );
    return Scaffold(
      appBar: appBar,
      body: Builder(builder: (context) => SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: (MediaQuery
              .of(context)
              .size
              .height - appBar.preferredSize.height) * 1,
          child: LayoutBuilder(builder: (cntx, constraints) {
            return Container(
              width: double.infinity,
              height: constraints.maxHeight * 1,
              child: Column(
                children: <Widget>[
                  Container(width: double.infinity,
                      height: constraints.maxHeight * 0.2,
                      child: EditProfileTop(widget.image)),
                  Center(
                    child: Column(
                      children: <Widget>[
                        EditProfileTextField(constraints.maxHeight * 0.02,
                            constraints.maxWidth * 0.8, Icons.person_outline,
                            "First Name", controller: firstNameController),
                        EditProfileTextField(constraints.maxHeight * 0.02,
                            constraints.maxWidth * 0.8, Icons.person_outline,
                            "Last Name", controller: lastNameController),
                        EditProfileTextField(constraints.maxHeight * 0.02,
                            constraints.maxWidth * 0.8, Icons.mail_outline,
                            "Email Address", controller: emailController),
                        EditProfileTextField(constraints.maxHeight * 0.02,
                            constraints.maxWidth * 0.8, Icons.phone_android,
                            "Phone Number", controller: phoneController)
                      ],
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        updateUser(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.03),
                        decoration: BoxDecoration(color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
                        width: constraints.maxWidth * 0.6,
                        child: Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Update Profile",
                            style: TextStyle(color: Colors.white),),)),
                      ),
                    ),
                  )
                ],
              ),
            );
          },),
        ),
      ),),
    );
  }

  Function updateUser(BuildContext context) {
    var condition = firstNameController.text ==
        widget.firstName &&
        lastNameController.text == widget.lastName &&
        emailController.text == widget.userEmail &&
        phoneController.text == widget.userPhone;
    var condition2 = firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty;
    if (condition) {
      buildSnackBar(context, "Fields Are Unchanged");
    } else if (condition2) {
      buildSnackBar(context,"All Fields Are Compulsory");
    } else {
      updateUserInfo(
          context,
          widget.userToken,
          widget.userId,
          widget.memberId,
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          phoneController.text);
    }
  }

  @override
  void initState() {
    if (widget.firstName != null)
      firstNameController.text = widget.firstName;
    if (widget.lastName != null)
      lastNameController.text = widget.lastName;
    if (widget.userEmail != null)
      emailController.text = widget.userEmail;
    if (widget.userPhone != null)
      phoneController.text = widget.userPhone;
    super.initState();
  }


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}