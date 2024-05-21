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
  final double stockPrice;

  UserModel({required this.data,required this.stocks,required this.selectedStock,required this.transactions,required this.stockPrice});

  UserModel.empty() : data = UserData.empty(),stocks = HashMap(),selectedStock= null,transactions = [],stockPrice = 0.00;

  UserModel copyWith({UserData? data,StockList? stocks,Stock? selectedStock,TransactionList? transactions,double? stockPrice}) {
    return UserModel(
        selectedStock: selectedStock??this.selectedStock,
        data: data??this.data,
        stocks: stocks??this.stocks,
        transactions: transactions??this.transactions,
        stockPrice: stockPrice??this.stockPrice
    );
  }

}