import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/helper/myTheme.dart';
import 'package:stock_market/helper/routes.dart';
import 'package:stock_market/views/auth/authView.dart';
import 'package:stock_market/views/wallet/walletView.dart';
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
          initialRoute: Routes.auth(),
          routes: {
            Routes.auth(): (context) => const AuthView(),
            Routes.wallet(): (context) => const WalletView(),
            Routes.stockHistory(): (context) => const StockView(),
            Routes.stocks(): (context) => const StocksView(),
            Routes.stocksTransactions(): (context) => const StockTransactionHistoryView()
          },
          debugShowCheckedModeBanner: false,
        )
    )
  );
}
