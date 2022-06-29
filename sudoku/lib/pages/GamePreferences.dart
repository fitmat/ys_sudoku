import 'package:flutter/cupertino.dart';

class GamePreferences extends ChangeNotifier {
  String difficultyLevel = "Easy";
  String theme = "Light";
  String color = "Cyan";

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
    notifyListeners();
  }
}
