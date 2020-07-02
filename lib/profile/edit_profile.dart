import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  String image;
  String firstName;
  String lastName;
  String userEmail;
  String userPhone;

  EditProfile({@required this.image,@required this.firstName,@required this.lastName,@required this.userEmail,@required this.userPhone});

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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 1,
          child: LayoutBuilder(builder: (cntx,constraints) {
            return Container(
              width: double.infinity,
              height: constraints.maxHeight * 1,
              child: Column(
                children: <Widget>[
                  Container(width: double.infinity,height: constraints.maxHeight * 0.2,child: buildTop()),
                  Center(
                    child: Column(
                      children: <Widget>[
                        profileTextField(constraints.maxHeight * 0.02, constraints.maxWidth * 0.8, Icons.person_outline, "First Name",controller: firstNameController),
                        profileTextField(constraints.maxHeight * 0.02, constraints.maxWidth * 0.8, Icons.person_outline, "Last Name",controller: lastNameController),
                        profileTextField(constraints.maxHeight * 0.02, constraints.maxWidth * 0.8, Icons.mail_outline, "Email Address",controller: emailController),
                        profileTextField(constraints.maxHeight * 0.02, constraints.maxWidth * 0.8, Icons.phone_android, "Phone Number",controller: phoneController)
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: constraints.maxHeight * 0.03),
                      decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(25)),
                      width: constraints.maxWidth * 0.6,
                      child: Center(child: Padding(padding: EdgeInsets.all(8.0),child: Text("Update Profile",style: TextStyle(color: Colors.white),),)),
                    ),
                  )
                ],
              ),
            );
          },),
        ),
      ),
    );
  }


  @override
  void initState() {
    if(widget.firstName != null)
    firstNameController.text = widget.firstName;
    if(widget.lastName != null)
    lastNameController.text = widget.lastName;
    if(widget.userEmail != null)
    emailController.text = widget.userEmail;
    if(widget.userPhone != null)
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

  LayoutBuilder buildTop() {
    return LayoutBuilder(builder: (cntx,constraints) {
      return Container(
        margin: EdgeInsets.only(top: constraints.maxHeight * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(image: widget.image == null ? AssetImage(
                      "assets/images/test.jpeg") : NetworkImage(widget.image),
                      fit: BoxFit.fill)),),
            Container(
              child: Padding(padding: EdgeInsets.all(8.0),child: Text("Upload",style: TextStyle(color: Colors.red),),),
            ),
          ],
        ),
      );
    },);
  }

  Container profileTextField(double margin,double width,IconData icon,String text,{@required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          prefixIcon: Icon(icon, color: Color(0xFFBFBFC8),),
          labelText: text,
          labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEBEAEF)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEBEAEF)),
          ),
        ),
      ),
    );
  }
}