import 'dart:collection';

import '../models/stock.dart';

class MyUser {
  final String? id;
  final String name;
  final String email;
  final double invested;
  final double balance;
  final HashMap<String,Stock> stocks;

  MyUser({this.id,required this.name,required this.email,required this.invested,required this.balance,required this.stocks});

  MyUser.empty() : id = null,name = "",email ="", invested = 0, balance = 0,stocks = HashMap();

  MyUser copyWith({double? balance,double? invested,HashMap<String,Stock>? stocks}) {
    return MyUser(id: id,
        name: name,
        email: email,
        invested: invested??this.invested,
        balance: balance??this.balance,
        stocks: stocks??this.stocks
    );

  }

}