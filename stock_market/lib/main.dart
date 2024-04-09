import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/views/auth/loginView.dart';
import 'package:stock_market/views/auth/registerView.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/profile": (context) => const ProfileView(),
        "/stock": (context) => const StockView(),
        "/stocks": (context) => const StocksView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
