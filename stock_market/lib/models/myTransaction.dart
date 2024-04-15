
enum MyAction{buy,sell}

class MyTransaction {
  final String userId;
  final String ticker;
  final DateTime timeStamp;
  final MyAction action;
  final double amount;
  final double price;
  final double stocks;

  MyTransaction({required this.userId,required this.ticker,required this.timeStamp,required this.action,required this.amount,required this.price,required this.stocks});

  double result(double current) {
    return price -current;
  }


}