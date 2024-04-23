import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/userData.dart';
import '../models/stock.dart';
import '../models/myTransaction.dart';
import '../models/appInfo.dart';
import '../models/userModel.dart';

class FirebaseAdapter {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference stocks = FirebaseFirestore.instance.collection("stocks");
  CollectionReference transactions = FirebaseFirestore.instance.collection("transactions");


  FirebaseAdapter();

  Future<void> register(String username,String email,String password) async {
    UserCredential c = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    String id = c.user!.uid;


    users.doc(email).set({
      "id":id,
      "email":email,
      "username":username,
      "balance": StartMoney,
      "invested": 0.00
    });

    return;
  }

  Future<void> login(String user,String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: user,password: password);
  }

  Future<UserModel> userData() async {
    User u = FirebaseAuth.instance.currentUser!;
    String id = u.uid;
    String email = u.email!;
    HashMap<String,Stock> stocks = HashMap();

    DocumentSnapshot<Object?> userData = await _userFromCol(id);

    UserData data = UserData(id: id,name: userData.get("name"), email: email, invested: userData.get("invested"), balance: userData.get("balance") );

    UserModel ret = UserModel(data: data, stocks: stocks, selectedStock: null, transactions: [],stockPrice: 0.00);

    //TODO Fetch Stocks

    return ret;
  }

  Future<UserModel> mocUser() async {
    String id = "thisIsMock";
    String name = "Sai";
    String email = "sailordi11@gmail.com";
    double invested1 = 500.00;
    double invested2 = 500.00;
    double balance = StartMoney - (invested1+invested2);
    HashMap<String,Stock> stocks = HashMap();
    String ticker1 = "GOOG";
    String ticker2 = "TSLA";
    double price1 = 50.00;

    UserData data = UserData(id: id,name: name, email: email, invested: invested1+invested2, balance: balance);

    Stock s1 = Stock(
        userId: id,
        ticker: ticker1,
        name: Stocks[ticker1]!,
        stocks:  invested1/price1,
        invested: invested1,
    );
    Stock s2 = Stock(
        userId: id,
        ticker: ticker2,
        name: Stocks[ticker2]!,
        stocks: 0,
        invested: 0,
    );

    stocks[ticker1] = s1;
    stocks[ticker2] = s2;

    return UserModel(data: data, stocks: stocks, selectedStock: null, transactions: [],stockPrice: 0.00);
  }

  Future<List<MyTransaction> > mocTransactions(String userId,String ticker) async {
    String ticker1 = "GOOG";
    String ticker2 = "TSLA";
    double invested1 = 500.00;
    double invested2 = 500.00;
    double price1 = 50.00;
    double price2 = 40.00;
    double price3 = 50.00;
    List<MyTransaction> ret = [];

    if(ticker == ticker1) {
      MyTransaction t = MyTransaction.buy(userId: userId, ticker: ticker1, amount: invested1, price: price1, stocks: invested1/price1);

      ret.add(t);
    }
    else {
      MyTransaction t1 = MyTransaction.buy(userId: userId, ticker: ticker2, amount: invested2, price: price2, stocks: invested2/price2);
      MyTransaction t2 = MyTransaction.sell(userId: userId, ticker: ticker2, amount: price3*t1.stocks, price: price3, stocks: t1.stocks);

      ret.add(t1);
      ret.add(t2);
    }

    return ret;
  }

  Future<void> updateUser(UserData u) async{
    users.doc(u.id).update({
      "balance":u.balance,
      "invested":u.invested
    });

  }

  Future<void> addTransaction(MyTransaction t) async {
    transactions.add({
      "userId":t.userId,
      "time":t.timeStamp,
      "action":t.action.name,
      "amount":t.amount,
      "ticker": t.ticker,
      "stocks":t.stocks,
      "price": t.price,
    });
  }

  Future<void> addStock(Stock s) async {
    stocks.doc(s.ticker).set({
      "userId":s.userId,
      "ticker": s.ticker,
      "invested":s.invested,
      "stocks": s.stocks
    });
  }

  Future<void> updateStock(Stock s) async {
    stocks.doc(s.ticker).update({
      "invested":s.invested,
      "stocks": s.stocks
    });
  }

  Future<DocumentSnapshot<Object?> > _userFromCol(String id) async {
    return users.doc(id).get();
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

}