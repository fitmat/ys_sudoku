import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences extends ChangeNotifier {
  static const DIFFICULTY_PREF = "difficulty";
  static String difficultyLevel = "Easy";

  static setDifficultyLevel(String difficulty) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(DIFFICULTY_PREF, difficulty);
  }

  static getDifficultyLevel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String difficulty = sharedPreferences.getString(DIFFICULTY_PREF);
    return difficulty ?? "Easy";
  }
}

// class GamePreferences extends ChangeNotifier {
//   String difficultyLevel = "Easy";

//   setDifficultyLevel(String difficulty) async {
//     difficultyLevel = difficulty;
//     notifyListeners();
//   }

//   // static getDifficultyLevel() async {
//   //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   //   String difficulty = sharedPreferences.getString(DIFFICULTY_PREF);
//   //   return difficulty ?? "Easy";
//   // }
// }
