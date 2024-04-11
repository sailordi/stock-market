import 'package:flutter/material.dart';

class Helper {
  static void circleDialog(BuildContext context) {
    showDialog(context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );
  }

  static void messageToUser(String str,BuildContext context) {
    showDialog(context: context,
        builder: (context) => Center(
          child: AlertDialog(
            title: Text(str),
          )
        )
    );  
  }


}