import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';
import 'package:sudoku/pages/GamePreferences.dart';

import '../Alerts.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  HomeScreen({key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    HomePageState.getPrefs().whenComplete(() {
      if (HomePageState.currentAccentColor == null) {
        HomePageState.currentAccentColor = 'Orange';
        HomePageState.setPrefs('currentAccentColor');
      }
      HomePageState.changeAccentColor(HomePageState.currentAccentColor, true);
      Provider.of<GamePreferences>(context, listen: false)
          .changeColor(HomePageState.currentAccentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: HomePageState.currentTheme == "light"
                ? Color(0xfffff9f1)
                : Color(0xff292929),
            bottomNavigationBar: buildBottomNavigationBar(),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('Sudoku',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Provider.of<GamePreferences>(context).selColor,
                            // Color(0xff004A62),
                            fontFamily: 'Gugi',
                            fontSize: 40,
                            fontWeight: FontWeight.w500)
                        // GoogleFonts.getFont('Gugi',
                        //     color: Color(0xff004A62),
                        //     fontSize: 40,
                        //     fontWeight: FontWeight.w500),
                        ),
                  ),
                ),
              ),
              Container(
                width: 390,
                height: MediaQuery.of(context).size.height * 0.78,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 275.7897033691406,
                      left: 60.8812484741211,
                      child: Transform.rotate(
                          angle: -1.13,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/sudoku_blocks.png"),
                                    fit: BoxFit.fitWidth),
                              )))),
                  Positioned(
                      top: 80,
                      left: 170.8812484741211,
                      child: Transform.rotate(
                        angle: -16,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/sudoku_blocks.png"),
                                  fit: BoxFit.fitWidth),
                            )),
                      )),
                  Positioned(
                      top: 54.6435241699219,
                      left: -16,
                      child: Transform.rotate(
                          angle: 0.24,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/sudoku_blocks.png"),
                                    fit: BoxFit.fitWidth),
                              )))),
                ]),
              ),
            ])));
  }

  Widget buildBottomNavigationBar() {
    return Container(
      child: BottomNavigationBar(
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // currentIndex: _selectedPage,
        unselectedItemColor: Colors.white.withOpacity(0.9),
        backgroundColor: Styles.primaryColor,
        // Color(0xff004A62),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        // onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          FontAwesomeIcons.cog,
                          color: Colors.white,
                          size: 30.0,
                        )),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/settings_screen');
              },
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.play,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                showAnimatedDialog<void>(
                    animationType: DialogTransitionType.fadeScale,
                    barrierDismissible: true,
                    duration: Duration(milliseconds: 350),
                    context: context,
                    builder: (_) => AlertStartGame());
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.of(context).pushNamed('/home_page');
                });
              },
            ),
            label: ('Play'),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.help_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/rules_page');
              },
            ),
            label: ('Rules'),
          ),
        ],
      ),
    );
  }
}
