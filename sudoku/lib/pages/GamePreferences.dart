import 'package:flutter/cupertino.dart';
import 'package:sudoku/Styles.dart';
import 'package:sudoku/main.dart';

class GamePreferences extends ChangeNotifier {
  String difficultyLevel = HomePageState.currentDifficultyLevel ?? "Easy";
  String theme = "Light";
  String color = "Cyan";
  Color selColor = Styles.ionicCyan[500];
  void changeDifficulty(String difficulty) {
    difficultyLevel = difficulty;
    notifyListeners();
  }

  void changeTheme(String selectedTheme) {
    theme = theme;
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
}
