import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/widgets/buySellWidget.dart';

import '../../managers/userManager.dart';
import '../../models/appInfo.dart';
import '../../widgets/stockWidget.dart';

const int TIME = 15000;

class StocksView extends ConsumerStatefulWidget {
  const StocksView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StocksViewState();
}

class _StocksViewState extends ConsumerState<StocksView> with WidgetsBindingObserver {
  late Timer _timer;
  List<GlobalKey<StockWidgetState> > _widgetKeys = [];
  final GlobalKey<BuySellWidgetState> _buySellWidgetState = GlobalKey<BuySellWidgetState>();

  @override
  void initState() {
    super.initState();
    List<String> tickers = Stocks.keys.toList();
    _widgetKeys = List.generate(tickers.length, (index) => GlobalKey<StockWidgetState>() );

    _timer = Timer.periodic(const Duration(milliseconds: TIME), (timer) {
      _buySellWidgetState.currentState?.getPrice();
      for (var key in _widgetKeys) {
        key.currentState?.getPrice();
      }

    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Save current state when the app becomes inactive
    if (state == AppLifecycleState.inactive) {
      ref.read(userManager.notifier).save();
    }
    super.didChangeAppLifecycleState(state);
  }

  void historyPage(String ticker) {
    Navigator.pushNamed(context,
        arguments: ticker,
        "/stock"
    );
  }

  void buy(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: _buySellWidgetState,
        action: MyAction.buy, 
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager);
          double am = double.parse(amount);

          MyTransaction t = MyTransaction(
              userId:data.id!,
              ticker: ticker,
              timeStamp:DateTime.now(),
              action: MyAction.buy,
              amount: am,
              price: price,
              stocks: am/price
          );

          String message = ref.read(userManager.notifier).buy(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
        }
    );
    
    showDialog(context: context,
        builder: (context) => w,
    );
    
  }

  void sell(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: _buySellWidgetState,
        action: MyAction.sell,
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager);
          double am = double.parse(amount);

          MyTransaction t = MyTransaction(
              userId:data.id!,
              ticker: ticker,
              timeStamp:DateTime.now(),
              action: MyAction.sell,
              amount: am*price,
              price: price,
              stocks: am
          );

          String message = ref.read(userManager.notifier).sell(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> tickers = Stocks.keys.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Stock market: stocks"),
      ),
      body:ListView.builder(
          itemCount: tickers.length,
          itemBuilder: (context,index) {
            return StockWidget(
              key: _widgetKeys[index],
              ticker: tickers[index],
              history: () { historyPage(tickers[index]); },
              buy: buy,
              sell: sell
            );
          }
      ),
    );
  }

}
