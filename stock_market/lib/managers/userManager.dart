import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/appInfo.dart';
import '../adapter/firebaseAdapter.dart';
import '../models/myTransaction.dart';
import '../models/userModel.dart';
import '../models/stock.dart';

class UserManager extends StateNotifier<UserModel> {
  final StateNotifierProviderRef ref;
  final FirebaseAdapter firebaseA = FirebaseAdapter();

  UserManager(this.ref) : super(UserModel.empty() ) {
    loadData();
  }

  void loadData() async {
    //TODO real data state = await firebaseA.userData();
    state = await firebaseA.mocUser();
  }

  void logOut() {
    firebaseA.logOut();

    save();

    state = UserModel.empty();
  }

  void save() {
    if(state.data.update) {
      firebaseA.updateUser(state.data);
      state = state.copyWith(data:state.data.copyWith(update: false) );
    }
  }

  String buy(MyTransaction t) {
    var uM = state;
    var u = uM.data;
    String ticker = t.ticker;

    if(u.balance <= 0) {
      return "Balance is zero can't buy";
    }
    if(u.balance-t.amount <= 0) {
      return "To little money to buy $ticker for ${t.amount}\$";
    }

    Stock s = Stock.empty(t.userId,ticker,Stocks[ticker]!);
    bool add = false;

    if(!uM.stocks.containsKey(ticker) ) {
      uM.stocks[ticker] = s;
      add = true;
    } else {
      s = uM.stocks[ticker]!;
    }

    s = s.copyWith(invested: s.invested+t.amount,stocks: s.stocks+t.stocks);

    if(add) {
      firebaseA.addStock(s);
    }
    else {
      firebaseA.updateStock(s);
    }

    firebaseA.addTransaction(t);

    uM.stocks[ticker] = s;

    u = u.copyWith(balance: u.balance-t.amount,invested: u.invested + t.amount,update: true);

    state = state.copyWith(data:u,stocks: uM.stocks);

    return "Bought ${t.stocks} $ticker for ${t.amount}\$";
  }

  String sell(MyTransaction t) {
    var uM = state;
    var u = uM.data;

    String ticker = t.ticker;

    if(!uM.stocks.containsKey(ticker) ) {
      return "You have no stocks in $ticker";
    }
    var s = uM.stocks[ticker];

    if(s!.stocks-t.stocks <= 0) {
      return "You only have ${s.stocks} of $ticker can not sell ${t.stocks} of $ticker";
    }
    firebaseA.addTransaction(t);

    s.transactions.add(t);

    s = s.copyWith(invested: s.invested-t.amount,stocks: s.stocks-t.stocks);

    u = u.copyWith(invested: u.invested-t.amount,balance: u.balance+t.amount,update: true);

    state = state.copyWith(data: u,stocks: uM.stocks);

    return "Sold ${t.stocks} $ticker for ${t.amount}\$";
  }

}

final userManager = StateNotifierProvider<UserManager,UserModel>((ref) {
  return UserManager(ref);
});