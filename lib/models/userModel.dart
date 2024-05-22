import 'dart:collection';

import 'userData.dart';
import 'stock.dart';
import 'myTransaction.dart';

typedef StockList = HashMap<String,Stock>;
typedef TransactionList = List<MyTransaction>;

class UserModel {
  final UserData data;
  final StockList stocks;
  final Stock? selectedStock;
  final TransactionList transactions;

  UserModel({required this.data,required this.stocks,required this.selectedStock,required this.transactions});

  UserModel.empty() : data = UserData.empty(),stocks = HashMap(),selectedStock= null,transactions = [];

  UserModel copyWith({UserData? data,StockList? stocks,Stock? selectedStock,TransactionList? transactions}) {
    return UserModel(
        selectedStock: selectedStock??this.selectedStock,
        data: data??this.data,
        stocks: stocks??this.stocks,
        transactions: transactions??this.transactions,
    );
  }

}