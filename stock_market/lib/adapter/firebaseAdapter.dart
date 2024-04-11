import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/myTransaction.dart';
import '../../models/appInfo.dart';

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
    });
    DateTime time = DateTime.now();

    MyTransaction t = MyTransaction(userId: id,timeStamp: time,action: Action.deposit,amount: StartMoney);

    await addTransaction(t);

    return;
  }

  Future<void> login(String user,String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: user,password: password);
  }

  Future<void> addTransaction(MyTransaction t) async {
    transactions.add({
      "userId":t.userId,
      "time":t.timeStamp,
      "action":t.action.name,
      "amount":t.amount,
      "ticker": t.ticker ?? "",
      "stocks":t.stocks ?? 0,
      "price": t.price ?? 0,
    });

    return;
  }


}