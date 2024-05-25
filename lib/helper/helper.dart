import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/buttonWidget.dart';

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
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonWidget(
                            text:"Ok",
                            tap: () { Navigator.pop(context); }
                        )
                      ],
                    )
                  ]
          ),
        ),
      );

  }

  static String formatCurrency(double price,[int decimals = 2]) {
    String ret = price.toStringAsFixed(decimals);

    return "$ret\$";
  }

  static String formatTimeStamp(DateTime t) {
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

    return formatter.format(t);
  }

  static void stockHistoryPage(BuildContext context,String ticker) {
    Navigator.pushNamed(context,
        arguments: ticker,
        "/stock"
    );
  }

}