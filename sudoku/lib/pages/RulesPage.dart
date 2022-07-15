import 'package:flutter/material.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

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

  ScrollController _scrollController = ScrollController();
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
            title: Text('How to Play?',
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
        body: VsScrollbar(
          controller: _scrollController,
          showTrackOnHover: true, // default false
          isAlwaysShown: true, // default false
          scrollbarFadeDuration: Duration(
              milliseconds: 500), // default : Duration(milliseconds: 300)
          scrollbarTimeToFade: Duration(
              milliseconds: 800), // default : Duration(milliseconds: 600)
          style: VsScrollbarStyle(
            hoverThickness: 10.0, // default 12.0
            radius: Radius.circular(10), // default Radius.circular(8.0)
            thickness: 6.0, // [ default 8.0 ]
            color: Colors.black, // default ColorScheme Theme
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                  child: Column(
                    children: [
                      Text("Sudoku Rules",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: HomePageState.currentTheme == "light"
                                  ? Styles.lightThemeprimaryColor
                                  : Styles.darkThemeprimaryColor,
                              fontFamily: 'Gugi',
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                            height: 2.0,
                            width: 180.0,
                            child: Container(
                              color: HomePageState.currentTheme == "light"
                                  ? Styles.lightThemeprimaryColor
                                  : Styles.darkThemeprimaryColor,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                            "1. Sudoku is played on a grid of 9 x 9 spaces.\n\n2. Each row, column, and square (9 spaces each) need to be filled out with the numbers 1-9, without repeating any numbers within the row, column or square.\n\n3. Sudoku is a game of logic and reasoning, so you shouldn’t have to guess. If you don’t know what number to put in a certain space, keep scanning the other areas of the grid until you see an opportunity to place a number. But don’t try to “force” anything – Sudoku rewards patience, insights, and recognition of patterns, not blind luck or guessing.",
                            style: TextStyle(
                              fontSize: 14,
                              color: HomePageState.currentTheme == "light"
                                  ? Styles.lightThemeprimaryColor
                                  : Styles.darkThemeprimaryColor,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
