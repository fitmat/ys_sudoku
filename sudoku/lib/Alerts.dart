import 'dart:async';
import 'dart:io';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/pages/GamePreferences.dart';
import 'package:sudoku/pages/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Styles.dart';
import 'main.dart';

import 'dart:math' as math;

class AlertGameOver extends StatefulWidget {
  static bool newGame = false;
  static bool restartGame = false;
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
    controller.play();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Color(0xffFFC8B7),
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
                  Text('Time : '),
                  Icon(FontAwesomeIcons.stopwatch)
                ]),
                Column(children: [
                  Text('${HomePageState.emptyBoxes}'),
                  Icon(FontAwesomeIcons.award)
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
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Color(0xffF96B3E), width: 5.0)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        child: Icon(FontAwesomeIcons.home, size: 40),
                        onTap: () {
                          Navigator.of(context).pushNamed('/home_screen');
                        }),
                    SizedBox(width: 10),
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
    'beginner',
    'easy',
    'medium',
    'hard'
  ];
  String currentDifficultyLevel;

  AlertDifficulty(String currentDifficultyLevel) {
    this.currentDifficultyLevel = currentDifficultyLevel;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xffF96B3E), width: 3.0)),
      title: Center(
          child: Text(
        'Set Difficulty ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Gugi',
        ),
      )),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                Divider(color: Colors.black),
                Text(level[0].toUpperCase() + level.substring(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: level == this.currentDifficultyLevel
                            ? Styles.primaryColor
                            : Colors.black)),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xffF96B3E), width: 3.0)),
      title: Text(
        'End Game',
        style: TextStyle(color: Styles.foregroundColor),
      ),
      content: Text(
        'Are you sure you want to end the game ?',
        style: TextStyle(color: Styles.foregroundColor),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xffF96B3E), width: 3.0)),
      title: Center(
          child: Text(
        'Select  Color',
        style: TextStyle(color: Colors.black),
      )),
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
            child: Column(
              children: [
                Divider(color: Colors.black),
                Center(
                  child: Text(color,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: color == this.currentAccentColor
                              ? Provider.of<GamePreferences>(context).selColor
                              : Colors.black)),
                ),
              ],
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xffF96B3E), width: 3.0)),
      title: Center(
        child: Text(
          'About',
          style: TextStyle(color: Colors.black),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/icon/icon_round.png',
              //     height: 48.0, width: 48.0, fit: BoxFit.contain),
              Text(
                '   Sudoku',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gugi',
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '                ',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Gugi', fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Version: 1.0.001 ',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Gugi', fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '                ',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Gugi', fontSize: 15),
              ),
            ],
          ),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xffF96B3E), width: 3.0)),
        title: Center(
          child: Text(
            'Sudoku',
            style: TextStyle(color: Color(0xff004A62)),
          ),
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Game Details'),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 4,
                        left: 0,
                        child: Container(
                            width: 142.5748291015625,
                            height: 46.78476333618164,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 20,
                                  left: 0,
                                  child: Text(
                                    'Difficulty',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: -0.000011207595889572985,
                                  left: 24.758502960205078,
                                  child: Text(
                                    '${Provider.of<GamePreferences>(context).difficultyLevel}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 24,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 67.00894165039062,
                        left: 13.659863471984863,
                        child: Container(
                            width: 122.08503723144531,
                            height: 38.95964431762695,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 28.4080753326416,
                                  left: 0.000012871359103883151,
                                  child: Text(
                                    'Hints',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 0.0000017772096043700003,
                                  left: 14.513618469238281,
                                  child: Text(
                                    '1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 24,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 67.00894165039062,
                        left: 108.4251708984375,
                        child: Container(
                            width: 142.5748291015625,
                            height: 51.1345329284668,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 24.34977912902832,
                                  left: -8.304102721012896e-7,
                                  child: Text(
                                    'Mistakes allowed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 0.0000017772096043700003,
                                  left: 26.465986251831055,
                                  child: Text(
                                    '3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 24,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 4,
                        left: 119,
                        child: Container(
                            width: 128.9149627685547,
                            height: 39.986549377441406,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 27,
                                  left: 0,
                                  child: Text(
                                    'Time',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 9.0986328125,
                                  child: Text(
                                    '12:00',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Gugi',
                                        fontSize: 24,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 175,
                        // left: MediaQuery.of(context).size.height * 0.2,
                        child: Transform.rotate(
                          angle: -0.47160482670297993 * (math.pi / 180),
                          child: Divider(
                              color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
                        )),
                    Positioned(
                      top: 0,
                      left: 10,
                      child:
                          // Transform.rotate(
                          //   angle: -90 * (math.pi / 180),
                          // child:
                          Divider(
                              color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
                      // )
                    ),
                    Positioned(
                      top: 150,
                      left: 80,
                      child: Row(
                        children: [
                          Text('Starting in'),
                          _buildValidityDisplayTimer(context),
                        ],
                      ),
                    )
                  ],
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
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.width * 0.08,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.width * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffd9d9d9),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    " $newClockTimer",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
