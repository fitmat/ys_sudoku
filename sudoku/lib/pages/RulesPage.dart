import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          title: Text('Rules',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont('Gugi',
                  color: Color(0xff004A62),
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Color(0xfffff9f1),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
    ));
  }
}
