import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truelink/buttons/check_public_key_btn.dart';
import 'package:truelink/buttons/object_browser_btn.dart';
import 'package:truelink/buttons/trx_browser_btn.dart';
import 'package:truelink/globals.dart' as globals;


class MenuDrawer extends StatefulWidget{
  @override
  MenuDrawerState createState() =>MenuDrawerState();
}

class MenuDrawerState extends State<MenuDrawer>
{
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child:ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child:globals.bkgImg,
            decoration: BoxDecoration(
              color: Colors.white38,
            ),
          ),

          BtnCheckKey(),
          ObjectBrowserButton(),
          TrxBrowserButton()
        ],
      ),
    );
  }
}