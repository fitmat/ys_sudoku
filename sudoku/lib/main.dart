import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:sudoku/pages/HomeScreen.dart';
import 'package:sudoku/pages/SettingsScreen.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'Styles.dart';
import 'Alerts.dart';
import 'SplashScreenPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String versionNumber = kIsWeb ? '2.4.1' : '2.4.0';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Styles.primaryColor,
      ),
      home: HomePage(),
      // HomeScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;
  List<List<List<int>>> gameList;
  List<List<int>> game;
  List<List<int>> gameCopy;
  List<List<int>> gameSolved;
  static String currentDifficultyLevel;
  static String currentTheme;
  static String currentAccentColor;
  static String platform;
  static bool isDesktop;
  List<int> selectedgameButton;
  bool isValidInput;
  static int mistakeCount = 0;
  static int number;
  static int numberSelected;

  @override
  void initState() {
    super.initState();
    try {
      doWhenWindowReady(() {
        appWindow.minSize = Size(800, 800);
      });
    } on UnimplementedError {}
    getPrefs().whenComplete(() {
      if (currentDifficultyLevel == null) {
        currentDifficultyLevel = 'easy';
        setPrefs('currentDifficultyLevel');
      }
      if (currentTheme == null) {
        if (MediaQuery.maybeOf(context)?.platformBrightness != null) {
          currentTheme =
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? 'light'
                  : 'dark';
        } else {
          currentTheme = 'dark';
        }
        setPrefs('currentTheme');
      }
      if (currentAccentColor == null) {
        currentAccentColor = 'Blue';
        setPrefs('currentAccentColor');
      }
      newGame(currentDifficultyLevel);
      changeTheme('set');
      changeAccentColor(currentAccentColor, true);
    });
    if (kIsWeb) {
      platform = 'web-' +
          defaultTargetPlatform
              .toString()
              .replaceFirst("TargetPlatform.", "")
              .toLowerCase();
      isDesktop = false;
    } else {
      platform = defaultTargetPlatform
          .toString()
          .replaceFirst("TargetPlatform.", "")
          .toLowerCase();
      isDesktop = ['windows', 'linux', 'macos'].contains(platform);
    }
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentDifficultyLevel = prefs.getString('currentDifficultyLevel');
      currentTheme = prefs.getString('currentTheme');
      currentAccentColor = prefs.getString('currentAccentColor');
    });
  }

  setPrefs(String property) async {
    final prefs = await SharedPreferences.getInstance();
    if (property == 'currentDifficultyLevel') {
      prefs.setString('currentDifficultyLevel', currentDifficultyLevel);
    } else if (property == 'currentTheme') {
      prefs.setString('currentTheme', currentTheme);
    } else if (property == 'currentAccentColor') {
      prefs.setString('currentAccentColor', currentAccentColor);
    }
  }

  void changeTheme(String mode) {
    setState(() {
      if (currentTheme == 'light') {
        if (mode == 'switch') {
          Styles.primaryBackgroundColor = Styles.darkGrey;
          Styles.secondaryBackgroundColor = Styles.grey;
          Styles.foregroundColor = Styles.white;
          currentTheme = 'dark';
        } else if (mode == 'set') {
          Styles.primaryBackgroundColor = Styles.white;
          Styles.secondaryBackgroundColor = Styles.white;
          Styles.foregroundColor = Styles.darkGrey;
        }
      } else if (currentTheme == 'dark') {
        if (mode == 'switch') {
          Styles.primaryBackgroundColor = Styles.white;
          Styles.secondaryBackgroundColor = Styles.white;
          Styles.foregroundColor = Styles.darkGrey;
          currentTheme = 'light';
        } else if (mode == 'set') {
          Styles.primaryBackgroundColor = Styles.darkGrey;
          Styles.secondaryBackgroundColor = Styles.grey;
          Styles.foregroundColor = Styles.white;
        }
      }
      setPrefs('currentTheme');
    });
  }

  void changeAccentColor(String color, [bool firstRun = false]) {
    setState(() {
      if (Styles.accentColors.keys.contains(color)) {
        Styles.primaryColor = Styles.accentColors[color];
      } else {
        currentAccentColor = 'Blue';
        Styles.primaryColor = Styles.accentColors[color];
      }
      if (color == 'Red') {
        Styles.secondaryColor = Styles.orange;
      } else {
        Styles.secondaryColor = Styles.lightRed;
      }
      if (!firstRun) {
        setPrefs('currentAccentColor');
      }
    });
  }

  void checkResult() {
    try {
      if (SudokuUtilities.isSolved(game)) {
        isButtonDisabled = !isButtonDisabled;
        gameOver = true;
        Timer(Duration(milliseconds: 500), () {
          showAnimatedDialog<void>(
              animationType: DialogTransitionType.fadeScale,
              barrierDismissible: true,
              duration: Duration(milliseconds: 350),
              context: context,
              builder: (_) => AlertGameOver()).whenComplete(() {
            if (AlertGameOver.newGame) {
              newGame();
              AlertGameOver.newGame = false;
            } else if (AlertGameOver.restartGame) {
              restartGame();
              AlertGameOver.restartGame = false;
            }
          });
        });
      }
    } on InvalidSudokuConfigurationException {
      return;
    }
  }

  static List<List<List<int>>> getNewGame([String difficulty = 'easy']) {
    int emptySquares;
    switch (difficulty) {
      case 'test':
        {
          emptySquares = 2;
        }
        break;
      case 'beginner':
        {
          emptySquares = 27;
        }
        break;
      case 'easy':
        {
          emptySquares = 36;
        }
        break;
      case 'medium':
        {
          emptySquares = 45;
        }
        break;
      case 'hard':
        {
          emptySquares = 54;
        }
        break;
    }
    SudokuGenerator generator = new SudokuGenerator(emptySquares: emptySquares);
    return [generator.newSudoku, generator.newSudokuSolved];
  }

  void setGame(int mode, [String difficulty = 'easy']) {
    if (mode == 1) {
      game = new List.generate(9, (i) => [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      gameCopy = SudokuUtilities.copySudoku(game);
      gameSolved = SudokuUtilities.copySudoku(game);
    } else {
      gameList = getNewGame(difficulty);
      game = gameList[0];
      gameCopy = SudokuUtilities.copySudoku(game);
      gameSolved = gameList[1];
    }
  }

  void showSolution() {
    setState(() {
      game = SudokuUtilities.copySudoku(gameSolved);
      isButtonDisabled =
          !isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = true;
    });
  }

  void newGame([String difficulty = 'easy']) {
    setState(() {
      setGame(2, difficulty);
      isButtonDisabled =
          isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  void restartGame() {
    setState(() {
      game = SudokuUtilities.copySudoku(gameCopy);
      isButtonDisabled =
          isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  void ValidateInput() {
    SudokuUtilities.isValidConfiguration(game) == false
        ? setState(() {
            isValidInput == false;
            mistakeCount++;
          })
        : setState(() {
            isValidInput == true;
          });
  }

  Color buttonColor(int k, int i) {
    Color color;
    if (([0, 1, 2].contains(k) && [3, 4, 5].contains(i)) ||
        ([3, 4, 5].contains(k) && [0, 1, 2, 6, 7, 8].contains(i)) ||
        ([6, 7, 8].contains(k) && [3, 4, 5].contains(i))) {
      if (Styles.primaryBackgroundColor == Styles.darkGrey) {
        color = Styles.grey;
      } else {
        color = Colors.grey[300];
      }
    } else {
      color = Styles.primaryBackgroundColor;
    }

    return color;
  }

  double buttonSize() {
    double size = 50;
    if (HomePageState.platform.contains('android') ||
        HomePageState.platform.contains('ios')) {
      size = 38;
    }
    return size;
  }

  double buttonFontSize() {
    double size = 20;
    if (HomePageState.platform.contains('android') ||
        HomePageState.platform.contains('ios')) {
      size = 16;
    }
    return size;
  }

  BorderRadiusGeometry buttonEdgeRadius(int k, int i) {
    if (k == 0 && i == 0) {
      return BorderRadius.only(topLeft: Radius.circular(5));
    } else if (k == 0 && i == 8) {
      return BorderRadius.only(topRight: Radius.circular(5));
    } else if (k == 8 && i == 0) {
      return BorderRadius.only(bottomLeft: Radius.circular(5));
    } else if (k == 8 && i == 8) {
      return BorderRadius.only(bottomRight: Radius.circular(5));
    }
    return BorderRadius.circular(0);
  }

  List<SizedBox> createButtons() {
    if (firstRun) {
      setGame(1);
      firstRun = false;
    }
    MaterialColor emptyColor;
    if (gameOver) {
      emptyColor = Styles.primaryColor;
    } else {
      emptyColor = Styles.secondaryColor;
    }
    List<SizedBox> buttonList = new List<SizedBox>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      var k = timesCalled;
      buttonList[i] = SizedBox(
        width: buttonSize(),
        height: buttonSize(),
        child: TextButton(
          onPressed: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () async {
                  selectedgameButton = [k, i];

                  callback([k, i], number);
                  number = null;

                  // showAnimatedDialog<void>(
                  //     barrierDismissible: true,
                  //     duration: Duration(milliseconds: 300),
                  //     context: context,
                  //     builder: (_) => InputNumbers()).whenComplete(() {
                  //   callback([k, i], InputNumbers.number);
                  //   InputNumbers.number = null;
                  //   ValidateInput();
                  // });
                },
          onLongPress: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () => callback([k, i], 0),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(buttonColor(k, i)),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return gameCopy[k][i] == 0
                    ? emptyColor
                    : Styles.foregroundColor;
              }
              return game[k][i] == 0
                  ? buttonColor(k, i)
                  : Styles.secondaryColor;
            }),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: buttonEdgeRadius(k, i),
            )),
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
              color: Styles.foregroundColor,
              width: 1,
              style: BorderStyle.solid,
            )),
          ),
          child: Text(
            game[k][i] != 0 ? game[k][i].toString() : ' ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: buttonFontSize()),
          ),
        ),
      );
    }
    timesCalled++;
    if (timesCalled == 9) {
      timesCalled = 0;
    }
    return buttonList;
  }

  Row oneRow() {
    return Row(
      children: createButtons(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<Row> createRows() {
    List<Row> rowList = new List<Row>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      rowList[i] = oneRow();
    }
    return rowList;
  }

  void callback(List<int> index, int number) {
    setState(() {
      if (number == null) {
        return;
      } else if (number == 0) {
        game[index[0]][index[1]] = number;
      } else {
        game[index[0]][index[1]] = number;
        checkResult();
      }
    });
  }

  showOptionModalSheet(BuildContext context) {
    BuildContext outerContext = context;
    showModalBottomSheet(
        context: context,
        backgroundColor: Styles.secondaryBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          final TextStyle customStyle =
              TextStyle(inherit: false, color: Styles.foregroundColor);
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.refresh, color: Styles.foregroundColor),
                title: Text('Restart Game', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(Duration(milliseconds: 200), () => restartGame());
                },
              ),
              ListTile(
                leading: Icon(Icons.add_rounded, color: Styles.foregroundColor),
                title: Text('New Game', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(Duration(milliseconds: 200),
                      () => newGame(currentDifficultyLevel));
                },
              ),
              ListTile(
                leading: Icon(Icons.lightbulb_outline_rounded,
                    color: Styles.foregroundColor),
                title: Text('Show Solution', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(Duration(milliseconds: 200), () => showSolution());
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.build_outlined, color: Styles.foregroundColor),
                title: Text('Set Difficulty', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(
                      Duration(milliseconds: 300),
                      () => showAnimatedDialog<void>(
                              animationType: DialogTransitionType.fadeScale,
                              barrierDismissible: true,
                              duration: Duration(milliseconds: 350),
                              context: outerContext,
                              builder: (_) => AlertDifficultyState(
                                  currentDifficultyLevel)).whenComplete(() {
                            if (AlertDifficultyState.difficulty != null) {
                              Timer(Duration(milliseconds: 300), () {
                                newGame(AlertDifficultyState.difficulty);
                                currentDifficultyLevel =
                                    AlertDifficultyState.difficulty;
                                AlertDifficultyState.difficulty = null;
                                setPrefs('currentDifficultyLevel');
                              });
                            }
                          }));
                },
              ),
              ListTile(
                leading: Icon(Icons.invert_colors_on_rounded,
                    color: Styles.foregroundColor),
                title: Text('Switch Theme', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(Duration(milliseconds: 200), () {
                    changeTheme('switch');
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens_outlined,
                    color: Styles.foregroundColor),
                title: Text('Change Accent Color', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(
                      Duration(milliseconds: 200),
                      () => showAnimatedDialog<void>(
                              animationType: DialogTransitionType.fadeScale,
                              barrierDismissible: true,
                              duration: Duration(milliseconds: 350),
                              context: outerContext,
                              builder: (_) => AlertAccentColorsState(
                                  currentAccentColor)).whenComplete(() {
                            if (AlertAccentColorsState.accentColor != null) {
                              Timer(Duration(milliseconds: 300), () {
                                currentAccentColor =
                                    AlertAccentColorsState.accentColor;
                                changeAccentColor(
                                    currentAccentColor.toString());
                                AlertAccentColorsState.accentColor = null;
                                setPrefs('currentAccentColor');
                              });
                            }
                          }));
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline_rounded,
                    color: Styles.foregroundColor),
                title: Text('About', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(
                      Duration(milliseconds: 200),
                      () => showAnimatedDialog<void>(
                          animationType: DialogTransitionType.fadeScale,
                          barrierDismissible: true,
                          duration: Duration(milliseconds: 350),
                          context: outerContext,
                          builder: (_) => AlertAbout()));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (kIsWeb) {
            return false;
          } else {
            showAnimatedDialog<void>(
                animationType: DialogTransitionType.fadeScale,
                barrierDismissible: true,
                duration: Duration(milliseconds: 350),
                context: context,
                builder: (_) => AlertExit());
          }
          return true;
        },
        child: new Scaffold(
          backgroundColor: Color(0xfffff9f1),
          extendBody: false,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: isDesktop
                  ? MoveWindow(
                      child: AppBar(
                        centerTitle: true,
                        title: Text('Sudoku'),
                        backgroundColor: Color(0xfffff9f1),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.minimize_outlined),
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
                            onPressed: () {
                              appWindow.minimize();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            padding: EdgeInsets.fromLTRB(8, 8, 20, 8),
                            onPressed: () {
                              showAnimatedDialog<void>(
                                  animationType: DialogTransitionType.fadeScale,
                                  barrierDismissible: true,
                                  duration: Duration(milliseconds: 350),
                                  context: context,
                                  builder: (_) => AlertExit());
                            },
                          ),
                        ],
                      ),
                    )
                  : AppBar(
                      centerTitle: true,
                      title: Text(
                        'Sudoku',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff004A62),
                          fontSize: 24.0,
                          fontFamily: 'Gugi',
                        ),
                      ),
                      backgroundColor: Color(0xfffff9f1),
                      elevation: 0.0,
                      iconTheme: IconThemeData(color: Colors.black),
                    )),
          endDrawer: Container(color: Colors.black, child: Text('HEY')),
          body: Builder(builder: (builder) {
            return Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [Text('Mode : $currentDifficultyLevel')],
                    ),
                    Row(
                      children: [Text('Mistake : $mistakeCount/3')],
                    ),
                  ],
                ),
                Flexible(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: createRows(),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('1',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 1;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('2',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 2;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('3',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 3;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('4',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 4;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('5',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 5;
                                }))
                      ],
                    ),
                    SizedBox(width: 25),
                    Row(
                      children: [
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('6',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 6;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('7',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 7;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('8',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 8;
                                })),
                        SizedBox(width: 25),
                        GestureDetector(
                            child: Container(
                                color: Color(0xffCECECE),
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text('9',
                                        style: TextStyle(fontSize: 32)))),
                            onTap: () => setState(() {
                                  number = 9;
                                }))
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Icon(FontAwesomeIcons.undo),
                        ElevatedButton(
                          child: Text('Undo'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffF96B3E)),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Column(
                      children: [
                        Icon(Icons.lightbulb_outlined),
                        ElevatedButton(
                          child: Text('Hints'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffF96B3E)),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Column(
                      children: [
                        Icon(FontAwesomeIcons.eraser),
                        ElevatedButton(
                            child: Text('Erase'),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xffF96B3E)),
                            onPressed: () {
                              callback(selectedgameButton, 0);
                            })
                      ],
                    )
                  ],
                ),
                Text('Bingo')
              ],
            );
          }),
        ));
    // floatingActionButton: FloatingActionButton(
    //   foregroundColor: Styles.primaryBackgroundColor,
    //   backgroundColor: Styles.primaryColor,
    //   onPressed: () => showOptionModalSheet(context),
    //   child: Icon(Icons.menu_rounded),
    // )));
  }

  Future<int> getNumber() async {
    return await Future.delayed(Duration(seconds: 1), () {
      return number;
    });
  }
}

// void isFilled(List<int> ButtonPosition){
//   i
// }


// class InputNumbers extends StatefulWidget {
//   @override
//   InputNumberState createState() => InputNumberState();

//   static get number {
//     return InputNumberState.number;
//   }

//   static set number(int number) {
//     InputNumberState.number = number;
//   }
// }

// class InputNumberState extends State<InputNumbers> {
//   static int number;
//   int numberSelected;
//   static final List<int> numberList1 = [1, 2, 3, 4, 5];
//   static final List<int> numberList2 = [6, 7, 8, 9];
//   // static final List<int> numberList3 = [7, 8, 9];

//   List<SizedBox> createButtons(List<int> numberList) {
//     return <SizedBox>[
//       for (int numbers in numberList)
//         SizedBox(
//           width: 38,
//           height: 38,
//           child: TextButton(
//             onPressed: () => {
//               setState(() {
//                 numberSelected = numbers;
//                 number = numberSelected;
//                 Navigator.pop(context);
//               })
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(
//                   Styles.secondaryBackgroundColor),
//               foregroundColor:
//                   MaterialStateProperty.all<Color>(Styles.primaryColor),
//               shape: MaterialStateProperty.all<OutlinedBorder>(
//                   RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               )),
//               side: MaterialStateProperty.all<BorderSide>(BorderSide(
//                 color: Styles.foregroundColor,
//                 width: 1,
//                 style: BorderStyle.solid,
//               )),
//             ),
//             child: Text(
//               numbers.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//         )
//     ];
//   }

//   Row oneRow(List<int> numberList) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: createButtons(numberList),
//     );
//   }

//   List<Row> createRows() {
//     List<List> numberLists = [numberList1, numberList2];
//     List<Row> rowList = new List<Row>.filled(2, null);
//     for (var i = 0; i <= 1; i++) {
//       rowList[i] = oneRow(numberLists[i]);
//     }
//     return rowList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//         // Column(
//         // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         // backgroundColor: Styles.secondaryBackgroundColor,
//         // title: Center(
//         //     child: Text(
//         //   'Choose a Number',
//         //   style: TextStyle(color: Styles.foregroundColor),
//         // )),
//         // content:
//         Padding(
//       padding: const EdgeInsets.only(bottom: 25.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: createRows(),
//       ),
//     );
//   }
// }
