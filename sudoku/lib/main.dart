// ignore_for_file: missing_required_param, missing_return

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:sudoku/pages/GamePreferences.dart';
import 'package:sudoku/pages/HomeScreen.dart';
import 'package:sudoku/pages/RulesPage.dart';
import 'package:sudoku/pages/SettingsScreen.dart';
import 'package:sudoku/pages/utils.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'Styles.dart';
import 'Alerts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(
      ChangeNotifierProvider(create: (_) => GamePreferences(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final String versionNumber = kIsWeb ? '2.4.1' : '2.4.0';
  static bool restartGame = false;
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Sudoku',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Styles.primaryColor,
        ),
        home: HomeScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SettingsScreen.routeName:
              return PageTransition(
                child: SettingsScreen(),
                duration: Duration(milliseconds: 375),
                settings: settings,
              );
            case HomePage.routeName:
              return PageTransition(
                child: HomePage(),
                duration: Duration(milliseconds: 375),
                settings: settings,
              );
            case RulesPage.routeName:
              return PageTransition(
                child: RulesPage(),
                duration: Duration(milliseconds: 375),
                settings: settings,
              );
            case HomeScreen.routeName:
              return PageTransition(
                child: HomeScreen(),
                duration: Duration(milliseconds: 375),
                settings: settings,
              );
            case AlertGameOver.routeName:
              return PageTransition(
                child: AlertGameOver(),
                duration: Duration(milliseconds: 375),
                settings: settings,
              );
          }
        },
      );
    });
  }
}

class HomePage extends StatefulWidget {
  static const String routeName = "/home_page";
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;
  List<List<List<int>>> gameList;
  List<List<int>> game;
  List<List<int>> gameCopy;
  List<List<int>> gameSolved;
  List<List<int>> hintList;
  int hint;
  static String currentDifficultyLevel;
  static String currentTheme;
  static String currentAccentColor;
  static String platform;
  static bool isDesktop;
  List<int> selectedgameButton;
  bool isValidInput;
  int mistakeCount = 0;
  int number;
  int numberSelected;
  int _counter = 0;
  Timer _timer;
  int rowNo;
  int columnNo;
  int hintCount = 0;
  int requiredTime;
  int emptyEntries = 0;
  int filledEntries = 0;
  bool isShowSolutionPressed;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
    mistakeCount = 0;
    isShowSolutionPressed = false;
    try {
      doWhenWindowReady(() {
        appWindow.minSize = Size(800, 800);
      });
    } on UnimplementedError {}
    getPrefs().whenComplete(() {
      if (currentDifficultyLevel == null) {
        currentDifficultyLevel = 'Beginner';
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
        currentAccentColor = 'Orange';
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
    _startTimerForOTP();
  }

  void _startTimerForOTP() {
    _counter = 0;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter >= 0) {
        setState(() {
          _counter++;
          requiredTime = _counter;
        });
      } else {
        setState(() {
          _counter = 0;
          _timer.cancel();
        });
      }
    });
  }

  void dispose() {
    _timer.cancel();
    _counter = 0;
    _animationController.dispose();
    super.dispose();
  }

  static Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    currentDifficultyLevel = prefs.getString('currentDifficultyLevel');
    currentTheme = prefs.getString('currentTheme');
    currentAccentColor = prefs.getString('currentAccentColor');
  }

  static setPrefs(String property) async {
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

  static void changeAccentColor(String color, [bool firstRun = false]) {
    if (Styles.accentColors.keys.contains(color)) {
      Styles.primaryColor = Styles.accentColors[color];
    } else {
      currentAccentColor = 'Cyan';
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
  }

  void checkResult() {
    try {
      if (SudokuUtilities.isSolved(game)) {
        isButtonDisabled = !isButtonDisabled;
        gameOver = true;
        Provider.of<GamePreferences>(context, listen: false)
            .setTimer(requiredTime);
        Utils.goToGameOverAlert(context, false, "Bingo", filledEntries);
      }
    } on InvalidSudokuConfigurationException {
      return;
    }
  }

  static int emptyBoxes;
  static List<List<List<int>>> getNewGame([String difficulty = 'Beginner']) {
    switch (difficulty) {
      case 'test':
        {
          emptyBoxes = 2;
        }
        break;
      case 'Beginner':
        {
          emptyBoxes = 27;
        }
        break;
      case 'Easy':
        {
          emptyBoxes = 36;
        }
        break;
      case 'Medium':
        {
          emptyBoxes = 45;
        }
        break;
      case 'Hard':
        {
          emptyBoxes = 54;
        }
        break;
    }
    SudokuGenerator generator = new SudokuGenerator(emptySquares: emptyBoxes);
    return [generator.newSudoku, generator.newSudokuSolved];
  }

  void setGame(int mode, [String difficulty = 'Beginner']) {
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
      isShowSolutionPressed = true;
      filledEntries = emptyBoxes;
      game = SudokuUtilities.copySudoku(gameSolved);
      isButtonDisabled =
          !isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = true;
      _timer.cancel();
    });
  }

  void showHint() {
    hintCount >= 1
        ? setState(() {
            final snackBar = SnackBar(
              content: Text(
                'OOPS! You have used all your hints.',
                style: TextStyle(
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemebackgroundColor
                      : Styles.darkThemebackgroundColor,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 80,
                  right: 20,
                  left: 20),
              backgroundColor: HomePageState.currentTheme == "light"
                  ? Styles.lightThemeprimaryColor
                  : Styles.darkThemeprimaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          })
        : setState(() {
            hintList = SudokuUtilities.copySudoku(gameSolved);

            hint = hintList[rowNo][columnNo];
            setState(() {
              game[rowNo][columnNo] = hint;
              hintCount++;
              filledEntries++;
            });
          });
  }

  void newGame([String difficulty = 'Easy']) {
    setState(() {
      setGame(2, difficulty);
      isButtonDisabled =
          isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  void restartGame() {
    setState(() {
      if (_timer.isActive == false) _startTimerForOTP();
      filledEntries = 0;
      game = SudokuUtilities.copySudoku(gameCopy);
      isButtonDisabled =
          isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  void checkNumberOfFilledEntries() {
    final gameList = game.expand((element) => element).toList();
    emptyEntries = gameList.where((element) => element == 0).length;
    filledEntries = emptyBoxes - emptyEntries;
  }

  void ValidateInput() {
    checkNumberOfFilledEntries();
    SudokuUtilities.isValidConfiguration(game) == false
        ? setState(() {
            isValidInput == false;
            mistakeCount++;
            HapticFeedback.heavyImpact();

            if (mistakeCount == 3) {
              _timer.cancel();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<GamePreferences>(context, listen: false)
                    .setTimer(requiredTime);
                Utils.goToGameOverAlert(
                    context, true, "Limit Exhausted", filledEntries);
                _counter = 0;
              });
            }
            setState(() {
              final snackBar = SnackBar(
                content: Text(
                  'OOPS! You have made mistake.',
                  style: TextStyle(
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemebackgroundColor
                        : Styles.darkThemebackgroundColor,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 80,
                    right: 20,
                    left: 20),
                backgroundColor: HomePageState.currentTheme == "light"
                    ? Styles.lightThemeprimaryColor
                    : Styles.darkThemeprimaryColor,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
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
        color = Styles.grey[300];
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
      size = MediaQuery.of(context).size.width * 0.09;
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
                  var val = selectedgameButton;
                  rowNo = val[0];
                  columnNo = val[1];
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
                  : Provider.of<GamePreferences>(context).selColor;
              // : Styles.secondaryColor;
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
                builder: (_) => _exitDialog());
            // Navigator.of(context).pushNamed('/home_screen');
          }
          return true;
        },
        child: new Scaffold(
          backgroundColor: HomePageState.currentTheme == "light"
              ? isShowSolutionPressed == false
                  ? Styles.lightThemebackgroundColor
                  : Styles.lightThemebackgroundColor.withOpacity(1.0)
              : isShowSolutionPressed == false
                  ? Styles.darkThemebackgroundColor
                  : Styles.lightThemebackgroundColor.withOpacity(1.0),
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
                                  builder: (_) => _exitDialog());
                            },
                          ),
                        ],
                      ),
                    )
                  : AppBar(
                      // automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text('Sudoku',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Styles.primaryColor,
                              fontFamily: 'Gugi',
                              fontSize: 40,
                              fontWeight: FontWeight.w500)),
                      backgroundColor: HomePageState.currentTheme == "light"
                          ? Styles.lightThemebackgroundColor
                          : Styles.darkThemebackgroundColor,
                      elevation: 0.0,
                      iconTheme: IconThemeData(
                        color: HomePageState.currentTheme == "light"
                            ? Styles.lightThemeprimaryColor
                            : Styles.darkThemeprimaryColor,
                      ),
                      actions: [
                        PopupMenuButton<int>(
                          position: PopupMenuPosition.over,
                          color: HomePageState.currentTheme == "light"
                              ? Styles.darkThemebackgroundColor.withOpacity(0.9)
                              : Styles.lightThemebackgroundColor
                                  .withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          icon: isShowSolutionPressed == false
                              ? Icon(
                                  Icons.menu_outlined,
                                  size: 30.0,
                                  color: HomePageState.currentTheme == "light"
                                      ? Styles.lightThemeprimaryColor
                                      : Styles.darkThemeprimaryColor,
                                )
                              : SizedBox(),
                          itemBuilder: isShowSolutionPressed == false
                              ? (context) => <PopupMenuItem<int>>[
                                    PopupMenuItem(
                                      value: 0,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              child: Text('Restart Game',
                                                  style: TextStyle(
                                                      color: HomePageState
                                                                  .currentTheme ==
                                                              "light"
                                                          ? Styles
                                                              .darkThemeprimaryColor
                                                          : Styles
                                                              .lightThemeprimaryColor,
                                                      fontFamily: 'Gugi',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              onTap: () {
                                                Navigator.pop(context);
                                                showAnimatedDialog<void>(
                                                    animationType:
                                                        DialogTransitionType
                                                            .fadeScale,
                                                    barrierDismissible: true,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    context: context,
                                                    builder: (_) =>
                                                        _restartGameDialog());

                                                // restartGame();
                                              }),
                                          Divider(
                                            color: HomePageState.currentTheme ==
                                                    "light"
                                                ? Styles.darkThemeprimaryColor
                                                : Styles.lightThemeprimaryColor,
                                          ),
                                          GestureDetector(
                                            child: Text('Show Solution',
                                                style: TextStyle(
                                                    color: HomePageState
                                                                .currentTheme ==
                                                            "light"
                                                        ? Styles
                                                            .darkThemeprimaryColor
                                                        : Styles
                                                            .lightThemeprimaryColor,
                                                    fontFamily: 'Gugi',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showAnimatedDialog<void>(
                                                  animationType:
                                                      DialogTransitionType
                                                          .fadeScale,
                                                  barrierDismissible: true,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  context: context,
                                                  builder: (_) =>
                                                      _showSolution());
                                            },
                                          ),
                                          Divider(
                                            color: HomePageState.currentTheme ==
                                                    "light"
                                                ? Styles.darkThemeprimaryColor
                                                : Styles.lightThemeprimaryColor,
                                          ),
                                          GestureDetector(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text('End Game',
                                                    style: TextStyle(
                                                        color: HomePageState
                                                                    .currentTheme ==
                                                                "light"
                                                            ? Styles
                                                                .darkThemeprimaryColor
                                                            : Styles
                                                                .lightThemeprimaryColor,
                                                        fontFamily: 'Gugi',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight
                                                            .normal))),
                                            onTap: () {
                                              Navigator.pop(context);
                                              // _timer.cancel();
                                              // setState(() {
                                              //   _exitDialog();
                                              // });
                                              showAnimatedDialog<void>(
                                                  animationType:
                                                      DialogTransitionType
                                                          .fadeScale,
                                                  barrierDismissible: true,
                                                  duration: Duration(
                                                      milliseconds: 350),
                                                  context: context,
                                                  builder: (_) =>
                                                      _exitDialog());
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                              : (context) => <PopupMenuItem<int>>[],
                          offset: Offset(0, 50),
                        ),
                      ],
                    )),
          body: Builder(builder: (builder) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text('Mode:',
                                style: GoogleFonts.getFont('Inter',
                                    color: HomePageState.currentTheme == "light"
                                        ? Styles.lightThemeprimaryColor
                                        : Styles.darkThemeprimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            Text(' $currentDifficultyLevel',
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  color: HomePageState.currentTheme == "light"
                                      ? Styles.lightThemeprimaryColor
                                      : Styles.darkThemeprimaryColor,
                                  fontSize: 16,
                                )),
                          ]),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: HomePageState.currentTheme == "light"
                                    ? Styles.lightThemeprimaryColor
                                    : Styles.darkThemeprimaryColor,
                              ),
                              _buildValidityDisplayTimer(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Mistake :',
                                  style: GoogleFonts.getFont('Inter',
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text(' $mistakeCount/',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    color: HomePageState.currentTheme == "light"
                                        ? Styles.lightThemeprimaryColor
                                        : Styles.darkThemeprimaryColor,
                                    fontSize: 16,
                                  )),
                              Text('3',
                                  style: TextStyle(
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '$filledEntries /',
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  color: HomePageState.currentTheme == "light"
                                      ? Styles.lightThemeprimaryColor
                                      : Styles.darkThemeprimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$emptyBoxes',
                                style: GoogleFonts.getFont('Inter',
                                    color: HomePageState.currentTheme == "light"
                                        ? Styles.lightThemeprimaryColor
                                        : Styles.darkThemeprimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: createRows(),
                  ),
                ),
                isShowSolutionPressed == false
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    child: Container(
                                        height: 8.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xffCECECE),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Center(
                                            child: Text('1',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    onTap: () => setState(() {
                                          number = 1;
                                          callback(selectedgameButton, number);
                                          ValidateInput();
                                          number = null;
                                        })),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                GestureDetector(
                                    child: Container(
                                        height: 8.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xffCECECE),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Center(
                                            child: Text('2',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    onTap: () => setState(() {
                                          number = 2;
                                          callback(selectedgameButton, number);
                                          ValidateInput();
                                          number = null;
                                        })),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                GestureDetector(
                                    child: Container(
                                        height: 8.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xffCECECE),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Center(
                                            child: Text('3',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    onTap: () => setState(() {
                                          number = 3;
                                          callback(selectedgameButton, number);
                                          ValidateInput();
                                          number = null;
                                        })),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                GestureDetector(
                                    child: Container(
                                        height: 8.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xffCECECE),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Center(
                                            child: Text('4',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    onTap: () => setState(() {
                                          number = 4;
                                          callback(selectedgameButton, number);
                                          ValidateInput();
                                          number = null;
                                        })),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                GestureDetector(
                                    child: Container(
                                        height: 8.h,
                                        width: 13.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xffCECECE),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Center(
                                            child: Text('5',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    onTap: () => setState(() {
                                          number = 5;
                                          callback(selectedgameButton, number);
                                          ValidateInput();
                                          number = null;
                                        }))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      child: Container(
                                          // color: Color(0xffCECECE),
                                          height: 8.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                              color: Color(0xffCECECE),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Center(
                                              child: Text('6',
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                      onTap: () => setState(() {
                                            number = 6;
                                            callback(
                                                selectedgameButton, number);
                                            ValidateInput();
                                            number = null;
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  GestureDetector(
                                      child: Container(
                                          // color: Color(0xffCECECE),
                                          height: 8.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                              color: Color(0xffCECECE),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Center(
                                              child: Text('7',
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                      onTap: () => setState(() {
                                            number = 7;
                                            callback(
                                                selectedgameButton, number);
                                            ValidateInput();
                                            number = null;
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  GestureDetector(
                                      child: Container(
                                          height: 8.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                              color: Color(0xffCECECE),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Center(
                                              child: Text('8',
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                      onTap: () => setState(() {
                                            number = 8;
                                            callback(
                                                selectedgameButton, number);
                                            ValidateInput();
                                            number = null;
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  GestureDetector(
                                      child: Container(
                                          height: 8.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                              color: Color(0xffCECECE),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Center(
                                              child: Text('9',
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                      onTap: () => setState(() {
                                            number = 9;
                                            callback(
                                                selectedgameButton, number);
                                            ValidateInput();
                                            number = null;
                                          }))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Game Over!",
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                isShowSolutionPressed == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outlined,
                                      size: 30.0,
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        width: 30.0.w,
                                        height: 5.0.h,
                                        child: ElevatedButton(
                                          child: Text('Hint ($hintCount/1)',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Styles.primaryColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            )),
                                          ),
                                          onPressed: () {
                                            showHint();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  showHint();
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            GestureDetector(
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.eraser,
                                      size: 30.0,
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        width: 21.0.w,
                                        height: 5.0.h,
                                        child: ElevatedButton(
                                          child: Text('Erase',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Styles.primaryColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            )),
                                          ),
                                          onPressed: () {
                                            callback(selectedgameButton, 0);
                                            checkNumberOfFilledEntries();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  callback(selectedgameButton, 0);
                                })
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.restart_alt,
                                      size: 30.0,
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        width: 30.0.w,
                                        height: 5.0.h,
                                        child: ElevatedButton(
                                          child: Text('Restart',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Styles.primaryColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            )),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/home_page');
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home_page');
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            GestureDetector(
                                child: Column(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.home,
                                      size: 30.0,
                                      color:
                                          HomePageState.currentTheme == "light"
                                              ? Styles.lightThemeprimaryColor
                                              : Styles.darkThemeprimaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        width: 23.0.w,
                                        height: 5.0.h,
                                        child: ElevatedButton(
                                          child: Text('Home',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Styles.primaryColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            )),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/home_screen');
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home_screen');
                                })
                          ],
                        ),
                      )
              ],
            );
          }),
        ));
  }

  Future<int> getNumber() async {
    return await Future.delayed(Duration(seconds: 1), () {
      return number;
    });
  }

  Widget _buildValidityDisplayTimer(BuildContext context) {
    Duration clockTimer = Duration(seconds: _counter);
    String newClockTimer =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
    if (_counter == 720) {
      Provider.of<GamePreferences>(context).isTimeBound == true
          ? WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<GamePreferences>(context, listen: false)
                  .setTimer(requiredTime);
              Utils.goToGameOverAlert(context, true, "Time Up", filledEntries);
              _counter = 0;
              _timer.cancel();
            })
          : null;
    }
    if (_counter > 660 &&
        Provider.of<GamePreferences>(context).isTimeBound == true &&
        _counter != 720) {
      HapticFeedback.heavyImpact();
      return FadeTransition(
          opacity: _animationController,
          child: Text(
            " $newClockTimer",
            style: GoogleFonts.getFont('Inter',
                color: Styles.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ));
    } else {
      return Text(
        " $newClockTimer",
        style: GoogleFonts.getFont('Inter',
            color: Provider.of<GamePreferences>(context).selColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      );
    }
  }

  Widget _exitDialog() {
    return SimpleDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Styles.primaryColor, width: 3.0)),
      title: Text(
        'End Game',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: HomePageState.currentTheme == "light"
              ? Styles.lightThemeprimaryColor
              : Styles.darkThemeprimaryColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Game progress would be lost. Do you really want to exit the game ?",
              style: TextStyle(
                  fontSize: 16,
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Inter'),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                HomePageState.currentTheme == "light"
                    ? Styles.lightThemeprimaryColor
                    : Styles.darkThemeprimaryColor,
              )),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                setState(() {
                  _timer.cancel();
                  _counter = 0;
                });
                Navigator.of(context).pushReplacementNamed('/home_screen');
              },
              child: Text('Yes'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _restartGameDialog() {
    return SimpleDialog(
        backgroundColor: HomePageState.currentTheme == "light"
            ? Styles.lightThemebackgroundColor
            : Styles.darkThemebackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Styles.primaryColor, width: 3.0)),
        title: Text(
          'Restart Game',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: HomePageState.currentTheme == "light"
                ? Styles.lightThemeprimaryColor
                : Styles.darkThemeprimaryColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Game progress would be lost. Do you want to restart the game ?",
                style: TextStyle(
                    fontSize: 16,
                    color: HomePageState.currentTheme == "light"
                        ? Styles.lightThemeprimaryColor
                        : Styles.darkThemeprimaryColor,
                    fontFamily: 'Inter'),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                  HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                )),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
              TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                  restartGame();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ]);
  }

  Widget _showSolution() {
    return SimpleDialog(
      backgroundColor: HomePageState.currentTheme == "light"
          ? Styles.lightThemebackgroundColor
          : Styles.darkThemebackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Styles.primaryColor, width: 3.0)),
      title: Text(
        'Show Solution',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: HomePageState.currentTheme == "light"
              ? Styles.lightThemeprimaryColor
              : Styles.darkThemeprimaryColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Game progress would be lost. Do you want to end game and see the solution?",
              style: TextStyle(
                  fontSize: 16,
                  color: HomePageState.currentTheme == "light"
                      ? Styles.lightThemeprimaryColor
                      : Styles.darkThemeprimaryColor,
                  fontFamily: 'Inter'),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                HomePageState.currentTheme == "light"
                    ? Styles.lightThemeprimaryColor
                    : Styles.darkThemeprimaryColor,
              )),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                showSolution();
              },
              child: Text('Yes'),
            ),
          ],
        ),
      ],
    );
  }
}
