import '../models/stock.dart';

class User {
  final int? id;
  final String name;
  final String password;
  final double invested;
  final double balance;
  final List<Stock>? stocks;

  User({this.id,required this.name,required this.password,required this.invested,required this.balance,this.stocks});

  User copyWith({double? balance,double? invested,List<Stock>? stocks}) {
    return User(id: id,
        name: name,
        password: password,
        invested: invested??this.invested,
        balance: balance??this.balance,
        stocks: stocks??this.stocks
    );

  }

}