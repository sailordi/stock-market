import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/adapter/firebaseAdapter.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/models/myUser.dart';
import 'package:stock_market/models/stock.dart';

import '../models/appInfo.dart';

class UserManager extends StateNotifier<MyUser> {
  final StateNotifierProviderRef ref;
  final FirebaseAdapter firebaseA = FirebaseAdapter();

  UserManager(this.ref) : super(MyUser.empty() ) {
    loadData();
  }

  void loadData() async {
    //TODO real data state = await firebaseA.userData();
    state = await firebaseA.mocUser();
  }

  void logOut() {
    firebaseA.logOut();

    save();

    state = MyUser.empty();
  }

  void save() {
    if(state.update) {
      firebaseA.updateUser(state);
      state = state.copyWith(update: false);
    }
  }

  String buy(MyTransaction t) {
    var u = state;
    String ticker = t.ticker;

    if(state.balance <= 0) {
      return "Balance is zero can't buy";
    }
    if(state.balance-t.amount <= 0) {
      return "To little money to buy $ticker for ${t.amount}\$";
    }

    Stock s = Stock.empty(t.userId,ticker,Stocks[ticker]!);
    bool add = false;

    if(!u.stocks.containsKey(ticker) ) {
      u.stocks[ticker] = s;
      add = true;
    } else {
      s = u.stocks[ticker]!;
    }

    s = s.copyWith(invested: s.invested+t.amount,stocks: s.stocks+t.stocks);

    if(add) {
      firebaseA.addStock(s);
    }
    else {
      firebaseA.updateStock(s);
    }

    firebaseA.addTransaction(t);

    u.stocks[ticker] = s;

    state = state.copyWith(balance: u.balance-t.amount,invested: u.invested + t.amount,stocks: u.stocks,update: true);

    return "Bought ${t.stocks} $ticker for ${t.amount}\$";
  }

  String sell(MyTransaction t) {
    var u = state;
    String ticker = t.ticker;

    if(!u.stocks.containsKey(ticker) ) {
      return "You have no stocks in $ticker";
    }
    var s = u.stocks[ticker];

    if(s!.stocks-t.stocks <= 0) {
      return "You only have ${s.stocks} of $ticker can not sell ${t.stocks} of $ticker";
    }
    firebaseA.addTransaction(t);

    s.transactions.add(t);

    s = s.copyWith(invested: s.invested-t.amount,stocks: s.stocks-t.stocks);

    state = state.copyWith(invested: u.invested-t.amount,balance: u.balance+t.amount,stocks: u.stocks,update: true);

    return "Sold ${t.stocks} $ticker for ${t.amount}\$";
  }

}

final userManager = StateNotifierProvider<UserManager,MyUser>((ref) {
  return UserManager(ref);
});