import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';

class GamePreferences extends ChangeNotifier {
  String difficultyLevel = HomePageState.currentDifficultyLevel ?? "Easy";
  String theme = "Light";
  String color = "Cyan";
  bool isTimeBound = false;
  Color selColor = Styles.ionicCyan[500];
  int completedTimer;

  void changeDifficulty(String difficulty) {
    difficultyLevel = difficulty;
    notifyListeners();
  }

  void changeTheme(String selectedTheme) async {
    final prefs = await SharedPreferences.getInstance();
    theme = selectedTheme;
    HomePageState.currentTheme = theme;
    prefs.setString('currentTheme', theme);
    notifyListeners();
  }

  void changeisTimeBound(bool isTimeBoundVal) {
    isTimeBound = isTimeBoundVal;
    notifyListeners();
  }

  void changeColor(String selectedColor) {
    color = selectedColor;
    if (Styles.accentColors.keys.contains(color)) {
      Styles.primaryColor = Styles.accentColors[color];
    }
    selColor = Styles.primaryColor;
    notifyListeners();
  }

  void setTimer(int timeRequired) {
    completedTimer = timeRequired;
    notifyListeners();
  }
}
