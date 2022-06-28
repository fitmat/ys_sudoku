import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Styles.dart';
import 'main.dart';

class AlertGameOver extends StatelessWidget {
  static bool newGame = false;

  static bool restartGame = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Styles.secondaryBackgroundColor,
      title: Text(
        'Game Over',
        style: TextStyle(color: Styles.foregroundColor),
      ),
      content: Text(
        'You successfully solved the Sudoku',
        style: TextStyle(color: Styles.foregroundColor),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.primaryColor)),
          onPressed: () {
            Navigator.pop(context);
            restartGame = true;
          },
          child: Text('Restart Game'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.primaryColor)),
          onPressed: () {
            Navigator.pop(context);
            newGame = true;
          },
          child: Text('New Game'),
        ),
      ],
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
      // backgroundColor: Styles.secondaryBackgroundColor,
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      children: <Widget>[
        for (String level in difficulties)
          SimpleDialogOption(
            onPressed: () {
              if (level != this.currentDifficultyLevel) {
                setState(() {
                  difficulty = level;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Styles.secondaryBackgroundColor,
      title: Text(
        'Exit Game',
        style: TextStyle(color: Styles.foregroundColor),
      ),
      content: Text(
        'Are you sure you want to exit the game ?',
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
            if (HomePageState.isDesktop) {
              exit(0);
            } else if (HomePageState.platform == 'android') {
              SystemNavigator.pop();
            }
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
                });
              }
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Divider(color: Colors.black),
                Text(color,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: color == this.currentAccentColor
                            ? Styles.primaryColor
                            : Colors.black)),
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
