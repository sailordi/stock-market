import '../models/transaction.dart';


class Stock {
  final int userId;
  final String ticker;
  final String name;
  final double? invested;
  final List<Transaction>? transactions;

  Stock({required this.userId,required this.ticker,required this.name,this.invested,this.transactions});

  Stock copyWith({double? invested}) {
    return Stock(userId: userId,
                  ticker: ticker,
                  name: name,
                  invested: invested??this.invested
    );
  }

  double result(double current) {
    if(transactions == null) {
      return 0;
    }
    double ret = 0;

    for(Transaction t in transactions!) {
      ret += t.result(current);
    }

    return ret;
  }

}