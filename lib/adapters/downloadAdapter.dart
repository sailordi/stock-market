import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:stock_market/models/stockHistoryData.dart';
import 'package:intl/intl.dart';

class DownloadAdapter {
  var port = 5001;
  String localHost = "";

  DownloadAdapter() {
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

  }

  Future<void> getPrice(String ticker,Function(String,double) set) async {
    var data = await _fetchStockPrice(ticker);

      set(ticker,data["rate"]);
  }

  Future<List<StockHistoryData> > getPriceHistory(String ticker,) async {
    var data = await _fetchPriceHistory(ticker);
    var values = data['values'] as List<dynamic>;
      List<StockHistoryData> ret = [];

      for(var data in values) {
        var c = data["close"] as double;
        var d = data["date"] as String;

        ret.add(StockHistoryData(price: c, dateStr: d) );
      }

      return ret;
  }

  Future<dynamic> _fetchStockPrice(String ticker) async {
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

  Future<dynamic> _fetchPriceHistory(String ticker) async {
    DateTime endD = DateTime.now();
    DateTime startD = DateTime(endD.year - 5,endD.month,endD.day);
    var formatter = DateFormat('yyyy-MM-dd');

    var url = Uri.parse('$localHost/hist/$ticker?start_date=${formatter.format(startD)}&end_date=${formatter.format(endD)}');


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

    return [];
  }

}