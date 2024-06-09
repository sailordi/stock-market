import 'package:intl/intl.dart';

class StockHistoryData {
  late double price;
  late DateTime date;

  StockHistoryData({required this.price,required String dateStr}) {
    DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

    date = dateFormat.parseUTC(dateStr);
  }

}