import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/Alerts.dart';
import 'package:sudoku/main.dart';
import 'package:sudoku/pages/GamePreferences.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings_screen";
  SettingsScreen({key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static String difficulty;
  static bool isTimeBound = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePreferences>(builder: (context, sudokuPref, child) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: Color(0xfffff9f1),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff004A62),
                      fontSize: 32.0,
                      fontFamily: 'Gugi',
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Difficulty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Container(
                                    width: 75,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffd9d9d9),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 13,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            child: Text(
                                              '${Provider.of<GamePreferences>(context).difficultyLevel}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showAnimatedDialog<void>(
                                        animationType:
                                            DialogTransitionType.fadeScale,
                                        barrierDismissible: true,
                                        duration: Duration(milliseconds: 350),
                                        context: context,
                                        builder: (_) =>
                                            // AlertGameOver());
                                            AlertDifficultyState(HomePageState
                                                .currentDifficultyLevel))
                                    .whenComplete(() {
                                  if (AlertDifficultyState.difficulty != null) {
                                    Timer(Duration(milliseconds: 300),
                                        () async {
                                      HomePageState.currentDifficultyLevel =
                                          AlertDifficultyState.difficulty;
                                      AlertDifficultyState.difficulty = null;
                                      HomePageState.setPrefs(
                                          'currentDifficultyLevel');
                                    });
                                  }
                                });
                              }),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Color",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Container(
                                    width: 75,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffd9d9d9),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 13,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 69,
                                          height: 22,
                                          child: Text(
                                            "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showAnimatedDialog<void>(
                                        animationType:
                                            DialogTransitionType.fadeScale,
                                        barrierDismissible: true,
                                        duration: Duration(milliseconds: 350),
                                        context: context,
                                        builder: (_) => AlertAccentColorsState(
                                            HomePageState.currentAccentColor))
                                    .whenComplete(() {
                                  if (AlertAccentColorsState.accentColor !=
                                      null) {
                                    Timer(Duration(milliseconds: 300), () {
                                      HomePageState.currentAccentColor =
                                          AlertAccentColorsState.accentColor;
                                      // changeAccentColor(
                                      //     currentAccentColor.toString());
                                      AlertAccentColorsState.accentColor = null;
                                      HomePageState.setPrefs(
                                          'currentAccentColor');
                                    });
                                  }
                                });
                              }),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Theme",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 75,
                                    height: 38,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 38,
                                          color: Colors.white,
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            "Light",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff636363),
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 75,
                                    height: 38,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 38,
                                          color: Color(0xff080202),
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 11,
                                          ),
                                          child: Text(
                                            "Dark",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Time Bound",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  //Todo: Add toggle On depending on Shared Preferences
                                  child: isTimeBound == false
                                      ? GestureDetector(
                                          child:
                                              Icon(FontAwesomeIcons.toggleOff),
                                          onTap: () {
                                            setState(() {
                                              isTimeBound = true;
                                            });
                                          })
                                      : GestureDetector(
                                          child:
                                              Icon(FontAwesomeIcons.toggleOn),
                                          onTap: () {
                                            setState(() {
                                              isTimeBound = false;
                                            });
                                          }))
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "About",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(FontAwesomeIcons.infoCircle),
                                  )
                                ],
                              ),
                              onTap: () {
                                showAnimatedDialog<void>(
                                    animationType:
                                        DialogTransitionType.fadeScale,
                                    barrierDismissible: true,
                                    duration: Duration(milliseconds: 350),
                                    context: context,
                                    builder: (_) => AlertAbout());
                              }),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text('Version:1.0.0.01'),
                        ),
                      ],
                    ),
                  )
                ],
              )));
    });
  }
}
