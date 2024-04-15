import '../models/myTransaction.dart';


class Stock {
  final String userId;
  final String ticker;
  final String name;
  final double invested;
  final double stocks;
  final List<MyTransaction> transactions;

  Stock({required this.userId,required this.ticker,required this.name,this.stocks = 0,this.invested = 0,required this.transactions});

  Stock.empty(this.userId,this.ticker,this.name) : stocks=0.00000,invested= 0.00,transactions = [];

  Stock copyWith({double? stocks,double? invested,List<MyTransaction>? transactions}) {
    return Stock(userId: userId,
                  ticker: ticker,
                  name: name,
                  stocks: stocks??this.stocks,
                  invested: invested??this.invested,
                  transactions: transactions?? this.transactions
    );
  }

  double result(double current) {
    if(transactions.isEmpty) {
      return 0;
    }
    double ret = 0;

    for(MyTransaction t in transactions) {
      ret += t.result(current);
    }

    return ret;
  }

}