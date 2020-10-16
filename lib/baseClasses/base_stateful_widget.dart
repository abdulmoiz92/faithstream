import 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  BaseStatefulWidget({Key key}) : super(key: key);
}

abstract class BaseStatefulWidgetState<Page extends BaseStatefulWidget>
    extends State<Page> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
}

mixin BasicPageMixin<Page extends BaseStatefulWidget>
on BaseStatefulWidgetState<Page> {
  Widget body(
      BuildContext context); // must implement if you own BasicPage mixin

  @override
  void initState() {
    super.initState();
    print("BasicPageMixin init of $this");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this.scaffoldKey,
      appBar: appBar_(),
      floatingActionButton: fab(),
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Widget fab() {
    // override it if you make a floating action button
    return Container();
  }

  Widget appBar_() {
    // override it, if you want to make an App Bar
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    print("BasicPageMixin dispose of: $this");
  }
}
