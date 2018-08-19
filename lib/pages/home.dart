import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:testflutter/pages/timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testflutter/utils/flutter_icon_icons.dart';

class HomePage extends StatelessWidget {
  Widget menuIcon(
      BuildContext context, Icon icon, String title, Widget nextPage) {
    return Container(
      decoration: BoxDecoration(
          border: const BorderDirectional(
              bottom: const BorderSide(color: const Color(0xFFCCCCCC)),
              end: const BorderSide(color: const Color(0xFFCCCCCC)))),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute<bool>(
              builder: (BuildContext context) => nextPage));
        },
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              Container(margin: EdgeInsets.only(top: 10.0), child: Text(title))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('Flutter Demo Gallery'),
      ),
      body: GridView.count(
        primary: false,
        crossAxisCount: 3,
        children: <Widget>[
          menuIcon(
              context,
              Icon(FontAwesomeIcons.stopwatch,
                  size: 48.0, color: Color(0xFFFF856C)),
              'Timer',
              TimerPage())
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
