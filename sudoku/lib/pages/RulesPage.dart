import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  static const String routeName = "/rules_page";
  const RulesPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rules"),
        ),
        body: Center(
          child: Text("Rules"),
        ),
      ),
    );
  }
}
