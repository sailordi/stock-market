
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

  MyTransaction.buy({required this.userId,required this.ticker,required this.amount,required this.price,required this.stocks}) : action = MyAction.buy,timeStamp=DateTime.now();
  MyTransaction.sell({required this.userId,required this.ticker,required this.amount,required this.price,required this.stocks}) : action = MyAction.sell,timeStamp=DateTime.now();

  double result(double current) {
    return price -current;
  }


}