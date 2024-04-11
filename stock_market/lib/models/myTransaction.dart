
enum Action{buy,sell,deposit}

class MyTransaction {
  final String userId;
  final String? ticker;
  final DateTime timeStamp;
  final Action action;
  final double amount;
  final double? price;
  final double? stocks;

  MyTransaction({required this.userId,this.ticker,required this.timeStamp,required this.action,required this.amount,this.price,this.stocks});

  double result(double current) {
    return price! -current;
  }


}