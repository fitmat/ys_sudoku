import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';

class RulesPage extends StatefulWidget {
  static const String routeName = "/rules_page";
  const RulesPage({key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HomePageState.currentTheme == "light"
            ? Color(0xfffff9f1)
            : Color(0xff292929),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,
            title: Text('Rules',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gugi',
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
            backgroundColor: Styles.primaryColor,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/sudoku_rules_image2.png"),
                          fit: BoxFit.fill),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Sudoku puzzles begin with a grid with some numbers already placed depending on the game's difficulty.\n\n Complete puzzles have each number from 1 to 9 appearing in each row, column, and block.\n\nFind out what numbers might fit in each cell on the grid.\n\nFill in a cell by tapping a number.",
                    style: TextStyle(
                      fontSize: 20,
                      color: HomePageState.currentTheme == "light"
                          ? Styles.lightThemeprimaryColor
                          : Styles.darkThemeprimaryColor,
                    )),
              ),
            ],
          ),
        ));
  }
}
