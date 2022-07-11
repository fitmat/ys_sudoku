import 'dart:async';
import 'dart:io';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sudoku/pages/GamePreferences.dart';
import 'package:sudoku/pages/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Styles.dart';
import 'main.dart';

import 'dart:math' as math;

class AlertGameOverArguments {
  final bool isTimerOver;

  AlertGameOverArguments({this.isTimerOver});
}

class AlertGameOver extends StatefulWidget {
  static bool newGame = false;
  static bool restartGame = false;
  // final bool isTimerOver;
  // const AlertGameOver({this.isTimerOver});

  @override
  State<AlertGameOver> createState() => _AlertGameOverState();
}

class _AlertGameOverState extends State<AlertGameOver> {
  bool isPlaying = true;
  final controller = ConfettiController();
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        isPlaying = controller.state == ConfettiControllerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context).settings.arguments as AlertGameOverArguments;
    // print("Args is: ${args.isTimerOver}");
    int timeRequiredToComplete =
        Provider.of<GamePreferences>(context).completedTimer;
    Duration clockTimer = Duration(seconds: timeRequiredToComplete);
    String newClockTimer =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
    controller.play();
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 1.0)),
      backgroundColor: Styles.primaryColor,
      title: Center(
        child: Text(
          'Game Over',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Gugi', fontSize: 30),
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Text(
                    '$newClockTimer',
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Icon(FontAwesomeIcons.stopwatch)
                ]),
                Column(children: [
                  Text('${HomePageState.emptyBoxes}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Completed', style: TextStyle(fontSize: 24)),
                ]),
              ],
            ),
            ConfettiWidget(
              confettiController: controller,
              blastDirectionality: BlastDirectionality.explosive,
            ),
            Text('Bingo !',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Styles.primaryColor, width: 5.0)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        child: Icon(FontAwesomeIcons.home, size: 40),
                        onTap: () {
                          Navigator.of(context).pushNamed('/home_screen');
                        }),
                    SizedBox(width: 15),
                    GestureDetector(
                      child: Icon(Icons.restart_alt, size: 40),
                      onTap: () {
                        Navigator.of(context).pushNamed('/home_page');
                      },
                    )
                  ]),
            )
          ],
        ),
      ),
      // actions: [
      //   Icon(FontAwesomeIcons.home),
      //   TextButton(
      //     style: ButtonStyle(
      //         foregroundColor:
      //             MaterialStateProperty.all<Color>(Styles.primaryColor)),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       restartGame = true;
      //     },
      //     child: Text('Restart Game'),
      //   ),
      //   TextButton(
      //     style: ButtonStyle(
      //         foregroundColor:
      //             MaterialStateProperty.all<Color>(Styles.primaryColor)),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       newGame = true;
      //     },
      //     child: Text('New Game'),
      //   ),
      // ],
    );
  }
}

// ignore: must_be_immutable
class AlertDifficultyState extends StatefulWidget {
  String currentDifficultyLevel;

  AlertDifficultyState(String currentDifficultyLevel) {
    this.currentDifficultyLevel = currentDifficultyLevel;
  }

  @override
  AlertDifficulty createState() => AlertDifficulty(this.currentDifficultyLevel);

  static get difficulty {
    return AlertDifficulty.difficulty;
  }

  static set difficulty(String level) {
    AlertDifficulty.difficulty = level;
  }
}

class AlertDifficulty extends State<AlertDifficultyState> {
  static String difficulty;
  static final List<String> difficulties = [
    'Beginner',
    'Easy',
    'Medium',
    'Hard'
  ];
  String currentDifficultyLevel;

  AlertDifficulty(String currentDifficultyLevel) {
    this.currentDifficultyLevel = currentDifficultyLevel;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Styles.primaryColor, width: 3.0),
      ),
      title: Center(
          child: Text('Set Difficulty ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Gugi',
                  fontSize: 32,
                  fontWeight: FontWeight.w500))
          //  GoogleFonts.getFont('Gugi',
          //     color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500),
          // )
          ),
      children: <Widget>[
        for (String level in difficulties)
          SimpleDialogOption(
            onPressed: () {
              if (level != this.currentDifficultyLevel) {
                setState(() {
                  difficulty = level;
                  Provider.of<GamePreferences>(context, listen: false)
                      .changeDifficulty(difficulty);
                });
              }
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Divider(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                ),
                Text(level[0].toUpperCase() + level.substring(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: level == this.currentDifficultyLevel
                            ? Styles.primaryColor
                            : HomePageState.currentTheme == "light"
                                ? Styles.lightThemeprimaryColor
                                : Styles.darkThemeprimaryColor,
                        fontFamily: 'Gugi',
                        fontSize: 20,
                        fontWeight: FontWeight.w500))
                // GoogleFonts.getFont('Gugi',
                //     color: level == this.currentDifficultyLevel
                //         ? Styles.primaryColor
                //         : Colors.black,
                //     fontSize: 20,
                //     fontWeight: FontWeight.w500)),
                // TextStyle(
                //     fontSize: 15,
                //     color: level == this.currentDifficultyLevel
                //         ? Styles.primaryColor
                //         : Colors.black)
                // ),
              ],
            ),
          ),
      ],
    );
  }
}

class AlertExit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Styles.primaryColor, width: 3.0)),
      title: Text(
        'End Game',
        style: TextStyle(
          color: HomePageState.currentTheme == "light"
              ? Styles.lightThemeprimaryColor
              : Styles.darkThemeprimaryColor,
        ),
      ),
      content: Container(
        child: Text(
          'Are you sure you want to end the game ?',
          style: TextStyle(
              color: HomePageState.currentTheme == "light"
                  ? Styles.lightThemeprimaryColor
                  : Styles.darkThemeprimaryColor,
              fontFamily: 'Inter'),
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.primaryColor)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.primaryColor)),
          onPressed: () {
            Navigator.of(context).pushNamed('/home_screen');
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}

class TimeOver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int timeRequiredToComplete =
        Provider.of<GamePreferences>(context).completedTimer;
    Duration clockTimer = Duration(seconds: timeRequiredToComplete);
    String newClockTimer =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 1.0)),
        backgroundColor: Styles.primaryColor,
        title: Center(
          child: Text(
            'Game Over',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Gugi', fontSize: 30),
          ),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      '$newClockTimer',
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(FontAwesomeIcons.stopwatch)
                  ]),
                  Column(children: [
                    Text(
                        '${HomePageState.filledEntries}/${HomePageState.emptyBoxes}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Completed', style: TextStyle(fontSize: 24)),
                  ]),
                ],
              ),
              SizedBox(width: 10),
              Text('Time Up!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Styles.primaryColor, width: 5.0)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Icon(FontAwesomeIcons.home, size: 40),
                          onTap: () {
                            Navigator.of(context).pushNamed('/home_screen');
                          }),
                      SizedBox(width: 15),
                      GestureDetector(
                        child: Icon(Icons.restart_alt, size: 40),
                        onTap: () {
                          Navigator.of(context).pushNamed('/home_page');
                        },
                      )
                    ]),
              )
            ],
          ),
        ));

    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed('/home_screen');
    // });
    // return AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       side: BorderSide(color: Styles.primaryColor, width: 3.0)),
    //   title: Text(
    //     "Time's Up",
    //     style: TextStyle(
    //       color: HomePageState.currentTheme == "light"
    //           ? Styles.lightThemeprimaryColor
    //           : Styles.darkThemeprimaryColor,
    //     ),
    //   ),
    //   content: Container(
    //     child: Text(
    //       'Better luck next time',
    //       style: TextStyle(
    //           color: HomePageState.currentTheme == "light"
    //               ? Styles.lightThemeprimaryColor
    //               : Styles.darkThemeprimaryColor,
    //           fontFamily: 'Inter'),
    //     ),
    //   ),
    // );
  }
}

class AlertNumbersState extends StatefulWidget {
  @override
  AlertNumbers createState() => AlertNumbers();

  static get number {
    return AlertNumbers.number;
  }

  static set number(int number) {
    AlertNumbers.number = number;
  }
}

class AlertNumbers extends State<AlertNumbersState> {
  static int number;
  int numberSelected;
  static final List<int> numberList1 = [1, 2, 3, 4, 5];
  static final List<int> numberList2 = [6, 7, 8, 9];
  // static final List<int> numberList3 = [7, 8, 9];

  List<SizedBox> createButtons(List<int> numberList) {
    return <SizedBox>[
      for (int numbers in numberList)
        SizedBox(
          width: 38,
          height: 38,
          child: TextButton(
            onPressed: () => {
              setState(() {
                numberSelected = numbers;
                number = numberSelected;
                Navigator.pop(context);
              })
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Styles.secondaryBackgroundColor),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.primaryColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
              side: MaterialStateProperty.all<BorderSide>(BorderSide(
                color: Styles.foregroundColor,
                width: 1,
                style: BorderStyle.solid,
              )),
            ),
            child: Text(
              numbers.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
    ];
  }

  Row oneRow(List<int> numberList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: createButtons(numberList),
    );
  }

  List<Row> createRows() {
    List<List> numberLists = [numberList1, numberList2];
    List<Row> rowList = new List<Row>.filled(2, null);
    for (var i = 0; i <= 1; i++) {
      rowList[i] = oneRow(numberLists[i]);
    }
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return
        // Column(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // backgroundColor: Styles.secondaryBackgroundColor,
        // title: Center(
        //     child: Text(
        //   'Choose a Number',
        //   style: TextStyle(color: Styles.foregroundColor),
        // )),
        // content:
        Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: createRows(),
      ),
    );
  }
}

// ignore: must_be_immutable
class AlertAccentColorsState extends StatefulWidget {
  String currentAccentColor;

  AlertAccentColorsState(String currentAccentColor) {
    this.currentAccentColor = currentAccentColor;
  }

  static get accentColor {
    return AlertAccentColors.accentColor;
  }

  static set accentColor(String color) {
    AlertAccentColors.accentColor = color;
  }

  @override
  AlertAccentColors createState() => AlertAccentColors(this.currentAccentColor);
}

class AlertAccentColors extends State<AlertAccentColorsState> {
  static String accentColor;
  static final List<String> accentColors = [...Styles.accentColors.keys];
  String currentAccentColor;

  AlertAccentColors(String currentAccentColor) {
    this.currentAccentColor = currentAccentColor;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Styles.primaryColor, width: 3.0)),
      title: Center(
          child: Text('Color Choice',
              style: TextStyle(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Gugi',
                  fontSize: 32,
                  fontWeight: FontWeight.w500))
          //  GoogleFonts.getFont('Gugi',
          //     color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500),
          // )
          ),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      children: <Widget>[
        for (String color in accentColors)
          SimpleDialogOption(
            onPressed: () {
              if (color != this.currentAccentColor) {
                setState(() {
                  accentColor = color;
                  Provider.of<GamePreferences>(context, listen: false)
                      .changeColor(color);
                });
              }
              Navigator.pop(context);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemeprimaryColor
                        : Styles.darkThemeprimaryColor,
                  ),
                  Center(
                      child: Text(color,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: color == this.currentAccentColor
                                  ? Styles.primaryColor
                                  : HomePageState.currentTheme == "light"
                                      ? Styles.lightThemeprimaryColor
                                      : Styles.darkThemeprimaryColor,
                              fontFamily: 'Gugi',
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                      // GoogleFonts.getFont('Gugi',
                      //     color: color == this.currentAccentColor
                      //         ? Provider.of<GamePreferences>(context).selColor
                      //         : Colors.black,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500),
                      // ),
                      ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AlertAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Styles.primaryColor, width: 3.0)),
      title: Center(
        child: Column(
          children: [
            Text('About',
                style: TextStyle(
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemeprimaryColor
                        : Styles.darkThemeprimaryColor,
                    fontFamily: 'Gugi',
                    fontSize: 32,
                    fontWeight: FontWeight.w500)),

            //   GoogleFonts.getFont('Gugi',
            //       color: Colors.black,
            //       fontSize: 32,
            //       fontWeight: FontWeight.w500),
            // ),
            Divider(
              color: HomePageState.currentTheme == "light"
                  ? Styles.lightThemeprimaryColor
                  : Styles.darkThemeprimaryColor,
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Sudoku',
              style: TextStyle(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Gugi',
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),

          // GoogleFonts.getFont('Gugi',
          //     color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
          // ),
          SizedBox(height: 5),
          Text('Version: 00.00.007 ',
              style: TextStyle(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Gugi',
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          // GoogleFonts.getFont('Gugi',
          //     color: Colors.black,
          //     fontSize: 20,
          //     fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class AlertStartGame extends StatefulWidget {
  const AlertStartGame({Key key}) : super(key: key);

  @override
  State<AlertStartGame> createState() => _AlertStartGameState();
}

class _AlertStartGameState extends State<AlertStartGame> {
  int _counter = 4;
  Timer _timer;
  void _startTimerForOTP() {
    _counter = 4;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        setState(() {
          _counter = 4;
          _timer.cancel();
        });
      }
    });
  }

  void initState() {
    super.initState();
    _startTimerForOTP();
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: HomePageState.currentTheme == "light"
            ? Styles.lightThemebackgroundColor
            : Styles.darkThemebackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Styles.primaryColor, width: 5.0)),
        title: Center(
            child: Text('Sudoku',
                style: TextStyle(
                    color: Styles.primaryColor,
                    fontFamily: 'Gugi',
                    fontSize: 32,
                    fontWeight: FontWeight.w500))
            //  GoogleFonts.getFont('Gugi',
            //     color: Color(0xff004A62),
            //     fontSize: 32,
            //     fontWeight: FontWeight.w500),
            // ),
            ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Details',
                style: TextStyle(
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemeprimaryColor
                        : Styles.darkThemeprimaryColor,
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.width * 0.58,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.03,
                          left: MediaQuery.of(context).size.width * 0.009,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width * 0.3,
                              // width: 142.5748291015625.w,
                              // height: 46.78476333618164.h,
                              child: Stack(children: <Widget>[
                                Positioned(
                                  top: 60.px,
                                  left: 60.px,
                                  child: Opacity(
                                    opacity: 0.30,
                                    child: Transform.rotate(
                                      angle: 1.57,
                                      child: Container(
                                        width: 110.px,
                                        height: 10.px,
                                        child: Divider(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                                  .withOpacity(0.7)
                                              : Styles.darkThemeprimaryColor
                                                  .withOpacity(0.7),
                                          height: 1.4.px,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 29.px,
                                    left: 10.758502960205078.px,
                                    child: Text(
                                      'Difficulty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                                  .withOpacity(0.5)
                                              : Styles.darkThemeprimaryColor
                                                  .withOpacity(0.5),
                                          fontFamily: 'Gugi',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: -0.000011207595889572985.px,
                                    left: 10.758502960205078.px,
                                    child: Center(
                                      child: Text(
                                        '${Provider.of<GamePreferences>(context).difficultyLevel}',
                                        style: TextStyle(
                                            color: HomePageState.currentTheme ==
                                                    "light"
                                                ? Styles.lightThemeprimaryColor
                                                : Styles.darkThemeprimaryColor,
                                            fontFamily: 'Inter',
                                            fontSize: 24,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.w500,
                                            height: 1),
                                      ),
                                    )),
                              ]))),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.2,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width * 0.2,
                              // width: 122.08503723144531.w,
                              // height: 42.95964431762695.h,
                              child: Stack(children: <Widget>[
                                Positioned(
                                  top: 0.px,
                                  left: 10.px,
                                  child: Opacity(
                                    opacity: 0.30,
                                    child: Container(
                                      width: 197.22.px,
                                      height: 1.px,
                                      child: Divider(
                                        color: HomePageState.currentTheme ==
                                                "light"
                                            ? Styles.lightThemeprimaryColor
                                                .withOpacity(0.7)
                                            : Styles.darkThemeprimaryColor
                                                .withOpacity(0.7),
                                        height: 1.4.px,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 40.4080753326416,
                                    left: 12.758502960205078.px,
                                    child: Text(
                                      'Hints',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                                  .withOpacity(0.5)
                                              : Styles.darkThemeprimaryColor
                                                  .withOpacity(0.5),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 15.0000017772096043700003.px,
                                    left: 20.758502960205078.px,
                                    child: Text(
                                      '1',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                          fontFamily: 'Inter',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )),
                              ]))),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.2,
                          left: MediaQuery.of(context).size.width * 0.35,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.2,
                              // width: 142.5748291015625.w,
                              // height: 54.1345329284668.h,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 40.4080753326416.px,
                                    left: 24.0986328125.px,
                                    child: Text(
                                      'Mistakes \n allowed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                                  .withOpacity(0.5)
                                              : Styles.darkThemeprimaryColor
                                                  .withOpacity(0.5),
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 15.0000017772096043700003.px,
                                    left: 42.465986251831055.px,
                                    child: Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                          fontFamily: 'Gugi',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )),
                              ]))),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.03,
                          left: MediaQuery.of(context).size.width * 0.37,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 29.px,
                                    left: 25.0986328125.px,
                                    child: Text(
                                      'Time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                                  .withOpacity(0.5)
                                              : Styles.darkThemeprimaryColor
                                                  .withOpacity(0.5),
                                          fontFamily: 'Gugi',
                                          fontSize: 14,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 0.px,
                                    left: 9.0986328125.px,
                                    child: Text(
                                      '12:00',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HomePageState.currentTheme ==
                                                  "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                          fontFamily: 'Inter',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    )),
                              ]))),
                      Positioned(
                        top: 170.px,
                        left: 80.px,
                        child: Row(
                          children: [
                            Text(
                              'Starting in',
                              style: TextStyle(
                                  color: HomePageState.currentTheme == "light"
                                      ? Styles.lightThemeprimaryColor
                                      : Styles.darkThemeprimaryColor),
                            ),
                            SizedBox(width: 6.px),
                            _buildValidityDisplayTimer(context),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]));
  }

  Widget _buildValidityDisplayTimer(BuildContext context) {
    Duration clockTimer = Duration(seconds: _counter);
    String newClockTimer =
        '${(clockTimer.inSeconds.remainder(60) % 60).toString()}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.09,
          height: MediaQuery.of(context).size.width * 0.09,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.width * 0.10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.primaryColor.withOpacity(0.7),
                ),
              ),
              Center(
                child: Text(
                  "$newClockTimer",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: HomePageState.currentTheme == "light"
                          ? Styles.lightThemeprimaryColor
                          : Styles.darkThemeprimaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
