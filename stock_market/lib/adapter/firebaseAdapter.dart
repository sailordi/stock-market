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