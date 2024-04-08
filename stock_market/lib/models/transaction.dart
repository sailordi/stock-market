
enum Action{buy,sell}

class Transaction {
  final int userId;
  final String ticker;
  final DateTime timeStamp;
  final Action action;
  final double amount;
  final double price;

  Transaction({required this.userId,required this.ticker,required this.timeStamp,required this.action,required this.amount,required this.price});

  double result(double current) {
    return price -current;
  }


}