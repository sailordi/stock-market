import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../models/userData.dart';
import '../models/stock.dart';
import '../models/myTransaction.dart';
import '../models/appInfo.dart';
import '../models/userModel.dart';

class FirebaseAdapter {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  CollectionReference _stocks(String userId) {
    return users.doc(userId).collection("stocks");
  }

  CollectionReference _transactions(String userId,String ticker) {
    return _stocks(userId).doc(ticker).collection("transactions");
  }

  FirebaseAdapter();

  Future<void> register(String username,String email,String password) async {
    try {
      UserCredential c = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String id = c.user!.uid;

      users.doc(id).set({
        "id":id,
        "email":email,
        "username":username,
        "balance": StartMoney,
        "invested": 0.00
      });

    } on FirebaseAuthException catch(e) {
      print("Exeption");
      rethrow;
    }
  }

  Future<void> login(String user,String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: user,password: password);
    } on FirebaseAuthException catch(e) {
      print("Exeption");
      rethrow;
    }
  }

  Future<UserModel> userData() async {
    User u = FirebaseAuth.instance.currentUser!;
    String id = u.uid;
    String email = u.email!;
    StockList stocks = StockList();

    var doc = await _userData(id);
    var userData = doc.data() as Map<String, dynamic>;

    UserData data = UserData(id: id,name: userData["name"], email: email, invested: userData["invested"], balance: userData["balance"]);

    stocks = await getStocks(id);

    UserModel ret = UserModel(data: data, stocks: stocks, selectedStock: null, transactions: [],stockPrice: 0.00);

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
    var doc = _transactions(t.userId,t.ticker).doc(_timestampToDb(t.timeStamp) );

      await doc.set({
        "action":t.action.name,
        "amount":t.amount,
        "stocks":t.stocks,
        "price": t.price,
      });

  }

  Future<void> addStock(Stock s) async {
    var doc = _stocks(s.userId).doc(s.ticker);

      await doc.set({
        "invested":s.invested,
        "stocks": s.stocks
      });
  }

  Future<void> updateStock(Stock s) async {
    _stocks(s.userId).doc(s.ticker).update({
      "invested":s.invested,
      "stocks": s.stocks
    });
  }

  Future<StockList> getStocks(String userId) async {
    var queryData = await _stocks(userId).get();
    StockList ret = StockList();

      for(var doc in queryData.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Stock s = Stock(userId: userId, ticker: doc.id, name: Stocks[doc.id]!,stocks: data["stocks"],invested: data["invested"]);

        ret[s.ticker] = s;
      }

      return ret;
  }

  Future<TransactionList> getTransactions(String userId,String ticker) async {
    var queryData = await _transactions(userId,ticker).get();
    TransactionList ret = [];

    for(var doc in queryData.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime timeStamp = _timestampFromDb(doc.id);
      MyAction action = (data["action"] == MyAction.buy.name) ? MyAction.buy: MyAction.sell;
      MyTransaction t = MyTransaction(
          userId: userId,
          ticker: ticker,
          timeStamp: timeStamp,
          action: action,
          amount: data["amount"],
          price: data["price"],
          stocks: data["stocks"]
      );

      ret.add(t);
    }

    return ret;
  }

  Future<DocumentSnapshot<Object?> > _userData(String id) async {
    return users.doc(id).get();
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  String _timestampToDb(DateTime d) {
    return d.toUtc().toString().replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '').substring(0, 14);
  }

  DateTime _timestampFromDb(String d) {
      // Define the format that matches the string
      DateFormat format = DateFormat("yyyyMMddHHmmss");

      // Use the format to parse the string
      return format.parseUtc(d);
  }

}