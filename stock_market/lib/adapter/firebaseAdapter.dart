import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/stock.dart';
import '../../models/myTransaction.dart';
import '../../models/appInfo.dart';
import '../models/myUser.dart';

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

  Future<MyUser> userData() async {
    User u = FirebaseAuth.instance.currentUser!;
    String id = u.uid;
    double balance = 0,invested = 0;
    String name = "",email = u.email!;
    HashMap<String,Stock> stocks = HashMap();

    DocumentSnapshot<Object?> userData = await _userFromCol(id);

    name = userData.get("name");
    balance = userData.get("balance");
    invested = userData.get("invested");

    MyUser ret = MyUser(id: id,email: email,invested: invested,balance: balance,name:name,stocks: stocks);

    //TODO Stocks

    return ret;
  }

  Future<MyUser> mocUser() async {
    String id = "thisIsMock";
    String name = "Sai";
    String email = "sailordi11@gmail.com";
    double invested = 500.00;
    double balance = StartMoney - invested;
    HashMap<String,Stock> stocks = HashMap();
    String ticker1 = "GOOG";
    String ticker2 = "TSLA";
    double price1 = 50.00;
    double price2 = 40.00;
    double price3 = 50.00;

    MyTransaction t1 = MyTransaction.buy(userId: id, ticker: ticker1, amount: invested, price: price1, stocks: invested/price1);
    MyTransaction t2 = MyTransaction.buy(userId: id, ticker: ticker2, amount: invested, price: price2, stocks: invested/price2);
    MyTransaction t3 = MyTransaction.sell(userId: id, ticker: ticker2, amount: price3*t2.stocks, price: price3, stocks: t2.stocks);

    List<MyTransaction> transactions1 = [];
    List<MyTransaction> transactions2 = [];

    transactions1.add(t1);
    transactions2.add(t2);
    transactions2.add(t3);

    Stock s1 = Stock(
        userId: id,
        ticker: ticker1,
        name: Stocks[ticker1]!,
        stocks: t1.stocks,
        invested: t1.amount,
        transactions: transactions1
    );
    Stock s2 = Stock(
        userId: id,
        ticker: ticker2,
        name: Stocks[ticker2]!,
        stocks: 0,
        invested: 0,
        transactions: transactions2
    );

    stocks[ticker1] = s1;
    stocks[ticker2] = s2;

    return MyUser(name: name, email: email, invested: invested, balance: balance, stocks: stocks);
  }

  Future<void> updateUser(MyUser u) async{
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