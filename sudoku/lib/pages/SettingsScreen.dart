import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/Alerts.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';
import 'package:sudoku/pages/GamePreferences.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings_screen";
  SettingsScreen({key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static bool isTimeBound = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home_screen');
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: HomePageState.currentTheme == "light"
                  ? Color(0xfffff9f1)
                  : Color(0xff292929),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  automaticallyImplyLeading: true,
                  centerTitle: true,
                  title: Text('Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HomePageState.currentTheme == "light"
                              ? Color(0xff000000)
                              : Color(0xffFFFFFF),
                          fontFamily: 'Gugi',
                          fontSize: 32,
                          fontWeight: FontWeight.w500)),
                  backgroundColor: HomePageState.currentTheme == "light"
                      ? Color(0xfffff9f1)
                      : Color(0xff292929),
                  elevation: 0.0,
                  iconTheme: IconThemeData(
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemeprimaryColor
                        : Styles.darkThemeprimaryColor,
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
                          color: HomePageState.currentTheme == "light"
                              ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                              : Styles.darkThemeprimaryColor.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Difficulty",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                          fontFamily: 'Gugi',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500)),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color(0xffd9d9d9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                  '${Provider.of<GamePreferences>(context).difficultyLevel}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Gugi',
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                        builder: (_) => AlertDifficultyState(
                                            HomePageState
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
                          color: HomePageState.currentTheme == "light"
                              ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                              : Styles.darkThemeprimaryColor.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Color",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                          fontFamily: 'Gugi',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500)),
                                  Container(
                                    width: 75,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Provider.of<GamePreferences>(context)
                                              .selColor,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 13,
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
                          color: HomePageState.currentTheme == "light"
                              ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                              : Styles.darkThemeprimaryColor.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Theme",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                      fontFamily: 'Gugi',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
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
                                        GestureDetector(
                                            child: Container(
                                              width: 75,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12)),
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                              ),
                                              child: Text("Light",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Gugi',
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            onTap: () {
                                              Provider.of<GamePreferences>(
                                                      context,
                                                      listen: false)
                                                  .changeTheme("light");
                                            }),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      child: Container(
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
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12)),
                                              ),
                                              child: Center(
                                                child: Text("Dark",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Gugi',
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Provider.of<GamePreferences>(context,
                                                listen: false)
                                            .changeTheme("dark");
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: HomePageState.currentTheme == "light"
                              ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                              : Styles.darkThemeprimaryColor.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Time Bound",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                      fontFamily: 'Gugi',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  //Todo: Add toggle On depending on Shared Preferences
                                  child: isTimeBound == false
                                      ? GestureDetector(
                                          child: Icon(
                                              FontAwesomeIcons.toggleOff,
                                              size: 30.0,
                                              color: HomePageState
                                                          .currentTheme ==
                                                      "light"
                                                  ? Styles
                                                      .lightThemeprimaryColor
                                                  : Styles
                                                      .darkThemeprimaryColor),
                                          onTap: () {
                                            setState(() {
                                              isTimeBound = true;
                                              Provider.of<GamePreferences>(
                                                      context,
                                                      listen: false)
                                                  .changeisTimeBound(true);
                                            });
                                          })
                                      : GestureDetector(
                                          child: Icon(FontAwesomeIcons.toggleOn,
                                              size: 30.0,
                                              color: HomePageState
                                                          .currentTheme ==
                                                      "light"
                                                  ? Styles
                                                      .lightThemeprimaryColor
                                                  : Styles
                                                      .darkThemeprimaryColor),
                                          onTap: () {
                                            setState(() {
                                              isTimeBound = false;
                                              Provider.of<GamePreferences>(
                                                      context,
                                                      listen: false)
                                                  .changeisTimeBound(false);
                                            });
                                          }))
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: HomePageState.currentTheme == "light"
                              ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                              : Styles.darkThemeprimaryColor.withOpacity(0.7),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: GestureDetector(
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Text("About",
                        //               textAlign: TextAlign.center,
                        //               style: TextStyle(
                        //                   color: HomePageState.currentTheme ==
                        //                           "light"
                        //                       ? Styles.lightThemeprimaryColor
                        //                       : Styles.darkThemeprimaryColor,
                        //                   fontFamily: 'Gugi',
                        //                   fontSize: 24,
                        //                   fontWeight: FontWeight.w500)),
                        //           Padding(
                        //             padding: const EdgeInsets.only(right: 8.0),
                        //             child: Icon(FontAwesomeIcons.infoCircle,
                        //                 color: HomePageState.currentTheme ==
                        //                         "light"
                        //                     ? Styles.lightThemeprimaryColor
                        //                     : Styles.darkThemeprimaryColor),
                        //           )
                        //         ],
                        //       ),
                        //       onTap: () {
                        //         showAnimatedDialog<void>(
                        //             animationType:
                        //                 DialogTransitionType.fadeScale,
                        //             barrierDismissible: true,
                        //             duration: Duration(milliseconds: 350),
                        //             context: context,
                        //             builder: (_) => AlertAbout());
                        //       }),
                        // ),
                        // Divider(
                        //     height: 1,
                        //     color: HomePageState.currentTheme == "light"
                        //         ? Styles.lightThemeprimaryColor.withOpacity(0.7)
                        //         : Styles.darkThemeprimaryColor
                        //             .withOpacity(0.7)),
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
                          child: Text('Version:00.00.014',
                              style: TextStyle(
                                color: HomePageState.currentTheme == "light"
                                    ? Styles.lightThemeprimaryColor
                                    : Styles.darkThemeprimaryColor,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}
