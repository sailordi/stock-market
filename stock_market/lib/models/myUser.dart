import 'dart:collection';

import '../models/stock.dart';

class MyUser {
  final String? id;
  final String name;
  final String email;
  final double invested;
  final double balance;
  final HashMap<String,Stock> stocks;
  final bool update;

  MyUser({this.id,required this.name,required this.email,required this.invested,required this.balance,required this.stocks,this.update = false});

  MyUser.empty() : id = null,name = "",email ="", invested = 0, balance = 0,stocks = HashMap(),update=false;

  MyUser copyWith({double? balance,double? invested,HashMap<String,Stock>? stocks,bool? update}) {
    return MyUser(id: id,
        name: name,
        email: email,
        invested: invested??this.invested,
        balance: balance??this.balance,
        stocks: stocks??this.stocks,
        update: update??this.update
    );

  }

}