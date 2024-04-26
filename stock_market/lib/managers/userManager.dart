import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/models/userData.dart';

import '../models/appInfo.dart';
import '../adapter/firebaseAdapter.dart';
import '../models/myTransaction.dart';
import '../models/userModel.dart';
import '../models/stock.dart';

class UserManager extends StateNotifier<UserModel> {
  final StateNotifierProviderRef ref;
  final FirebaseAdapter firebaseA = FirebaseAdapter();

  UserManager(this.ref) : super(UserModel.empty() ) {
    //Todo enable for moc
    // _loadData();
  }

  Future<void> loadData() async {
    state = await firebaseA.userData();
  }

  void logOut() {
    state = UserModel.empty();

    firebaseA.logOut();
  }

  Future<void> logIn(String email,String password) async {
    await firebaseA.login(email, password);
  }

  Future<void> register(String username,String email,String password) async {
    await firebaseA.register(username,email, password);
    await logIn(email,password);
  }

  Future<String> buy(MyTransaction t) async {
    var uM = state;
    var u = uM.data;
    bool sel = false;
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

    if(uM.selectedStock != null && t.ticker == uM.selectedStock!.ticker) {
      uM.transactions.add(t);
      sel = true;
    }

    uM.stocks[ticker] = s;

    u = u.copyWith(balance: u.balance-t.amount,invested: u.invested + t.amount);

    await firebaseA.addTransaction(t);
    if(add) {
      await firebaseA.addStock(s);
    }
    else {
      await firebaseA.updateStock(s);
    }
    await firebaseA.updateUser(u);

    if(!sel) {
      state = state.copyWith(data: u, stocks: uM.stocks);
    }else {
      state = state.copyWith(data: u, stocks: uM.stocks,selectedStock: s,transactions: uM.transactions);
    }

    return "Bought ${t.stocks} $ticker for ${t.amount}\$";
  }

  Future<String>  sell(MyTransaction t) async {
    var uM = state;
    var u = uM.data;
    bool sel = false;

    String ticker = t.ticker;

    if(!uM.stocks.containsKey(ticker) ) {
      return "You have no stocks in $ticker";
    }
    var s = uM.stocks[ticker];

    if(s!.stocks-t.stocks <= 0) {
      return "You only have ${s.stocks} of $ticker can not sell ${t.stocks} of $ticker";
    }
    s = s.copyWith(invested: s.invested-t.amount,stocks: s.stocks-t.stocks);

    if(uM.selectedStock != null && t.ticker == uM.selectedStock!.ticker) {
      uM.transactions.add(t);
      sel = true;
    }

    s = s.copyWith(invested: s.invested-t.amount,stocks: s.stocks-t.stocks);
    u = u.copyWith(invested: u.invested-t.amount,balance: u.balance+t.amount);

    await firebaseA.addTransaction(t);
    await firebaseA.updateStock(s);
    await firebaseA.updateUser(u);

    if(!sel) {
      state = state.copyWith(data: u, stocks: uM.stocks);
    }else {
      state = state.copyWith(data: u, stocks: uM.stocks,selectedStock: s,transactions: uM.transactions);
    }

    return "Sold ${t.stocks} $ticker for ${t.amount}\$";
  }

  Future<void> selectStock(String ticker,double price) async {
    //TODO Real transaction
    var transactions = await firebaseA.getTransactions(state.data.id!,ticker);
    //var transactions = await firebaseA.mocTransactions(s.userId,s.ticker);

    state = state.copyWith(selectedStock: state.stocks[ticker],transactions: transactions,stockPrice: price);
  }

}

final userManager = StateNotifierProvider<UserManager,UserModel>((ref) {
  return UserManager(ref);
});