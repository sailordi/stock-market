import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/helper/myTheme.dart';
import 'package:stock_market/views/auth/authView.dart';
import 'package:stock_market/views/profile/profileView.dart';
import 'package:stock_market/views/stocks/stockView.dart';
import 'package:stock_market/views/stocks/stocksView.dart';
import 'package:stock_market/views/transactions/stockTransactionHistoryView.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
        child: MaterialApp(
          title: 'Stock market',
          theme: MyTheme.lightMode(),
          darkTheme: MyTheme.darkMode(),
          initialRoute: "/profile",
          routes: {
            "/": (context) => const AuthView(),
            "/profile": (context) => const ProfileView(),
            "/stock": (context) => const StockView(),
            "/stocks": (context) => const StocksView(),
            "/stockTransactions": (context) => const StockTransactionHistoryView()
          },
          debugShowCheckedModeBanner: false,
        )
    )
  );
}
