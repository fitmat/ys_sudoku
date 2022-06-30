import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  static const String routeName = "/rules_page";
  const RulesPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: Color(0xfffff9f1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Rules',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff004A62),
              fontSize: 24.0,
              fontFamily: 'Gugi',
            ),
          ),
          backgroundColor: Color(0xfffff9f1),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
    ));
  }
}
