import 'dart:collection';

import '../models/stock.dart';

class UserData {
  final String? id;
  final String name;
  final String email;
  final double invested;
  final double balance;
  final bool update;

  UserData({this.id,required this.name,required this.email,required this.invested,required this.balance,this.update = false});

  UserData.empty() : id = null,name = "",email ="", invested = 0, balance = 0,update=false;

  UserData copyWith({double? balance,double? invested,bool? update}) {
    return UserData(id: id,
        name: name,
        email: email,
        invested: invested??this.invested,
        balance: balance??this.balance,
        update: update??this.update
    );

  }

}