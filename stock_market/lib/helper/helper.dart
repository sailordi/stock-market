import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  static Future<dynamic?> stockPrice(String ticker) async {
    var port = 5001;
    String localHost = "";

    // Check if the app is running on Android
    if (Platform.isAndroid) {
      // Use 10.0.2.2 for Android emulator to connect to the localhost of the host machine
      localHost = 'http://10.0.2.2:$port';
    } else if (Platform.isIOS) {
      // Use localhost for iOS simulator
      localHost = 'http://localhost:$port';
    } else {
      // Default (you can extend this logic for other platforms or use a remote URL)
      localHost = 'http://localhost:$port';
    }
    var url = Uri.parse('$localHost/exchange_rate/$ticker');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var d = json.decode(response.body);
        return d;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load exchange rate');
      }
    } catch (e) {
      print('Caught exception: $e');
    }

    return null;

  }

  static String formatCurrency(double price,[int decimals = 2]) {
    String ret = price.toStringAsFixed(decimals);

    return "$ret\$";
  }

  static void stockHistoryPage(BuildContext context,String ticker) {
    Navigator.pushNamed(context,
        arguments: ticker,
        "/stock"
    );
  }

  static Future<void> getPrice(String ticker,Function(double) set) async {
    var data = await Helper.stockPrice(ticker);

      set(data["rate"]);
  }

}