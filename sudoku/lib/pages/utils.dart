import 'package:flutter/material.dart';

class Utils {
  static void goToGameOverAlert(BuildContext context,
      [bool isTimeUp, String text, int filledEntries]) {
    Navigator.pushReplacementNamed(context, '/alert_game_over',
        arguments: [isTimeUp, text, filledEntries]);
  }
}
