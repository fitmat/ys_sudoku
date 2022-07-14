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
                          image:
                              AssetImage("assets/images/sudoku_rules_img2.png"),
                          fit: BoxFit.fill),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    'A Sudoku puzzle begins with grid in which some of the numbers are already in place depending on the game difficulty level.\nA completed puzzle is one where each number from 1 to 9 appears only once in each of the 9 rows, columns and blocks.Study the grid to find the numbers that might fit into each cell.\nSelect a cell then tap a number to fill in the cell.',
                    style: TextStyle(
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
