import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/helper/myTheme.dart';
import 'package:stock_market/views/auth/authView.dart';
import 'package:stock_market/views/profile/profileView.dart';
import 'package:stock_market/views/stocks/stockView.dart';
import 'package:stock_market/views/stocks/stocksView.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock market',
      theme: MyTheme.lightMode(),
      darkTheme: MyTheme.darkMode(),
      initialRoute: "/stocks",
      routes: {
        "/": (context) => const AuthView(),
        "/profile": (context) => const ProfileView(),
        "/stock": (context) => const StockView(),
        "/stocks": (context) => const StocksView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
