import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/widgets/profileStockWidget.dart';
import 'package:stock_market/widgets/stockWidget.dart';

import '../helper/helper.dart';
import '../managers/userManager.dart';
import '../models/myTransaction.dart';
import '../models/stock.dart';
import 'buySellWidget.dart';

const int TIME = 1500;

class StockListWidget extends ConsumerStatefulWidget {
  final List<String>? tickers;
  final List<Stock>? stocks;

  const StockListWidget({super.key,this.tickers,this.stocks});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StockListWidgetState();

}

class _StockListWidgetState extends ConsumerState<StockListWidget> with WidgetsBindingObserver {
  late Timer _timer;
  late List<GlobalKey<StockWidgetState> > _stockKeys;
  late List<GlobalKey<ProfileStockWidgetState> > _profileKeys;
  final GlobalKey<BuySellWidgetState> _buySellWidgetState = GlobalKey<BuySellWidgetState>();

  @override
  void initState() {
    super.initState();

    if(widget.tickers != null) {
      _stockKeys = List.generate(widget.tickers!.length, (index) => GlobalKey<StockWidgetState>() );

      _timer = Timer.periodic(const Duration(milliseconds: TIME), (timer) {
        _buySellWidgetState.currentState?.getPrice();
        for (var key in _stockKeys!) {
          key.currentState?.getPrice();
        }

      });
    }
    else {
      _profileKeys = List.generate(widget.stocks!.length, (index) => GlobalKey<ProfileStockWidgetState>() );

      _timer = Timer.periodic(const Duration(milliseconds: TIME), (timer) {
        _buySellWidgetState.currentState?.getPrice();
        for (var key in _profileKeys!) {
          key.currentState?.getPrice();
        }
      });
    }

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

          MyTransaction t = MyTransaction.buy(
              userId:data.id!,
              ticker: ticker,
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

          MyTransaction t = MyTransaction.sell(
              userId:data.id!,
              ticker: ticker,
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

  dynamic stocksWidget() {
    List<String> data = widget.tickers!;

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context,index) {
            return StockWidget(
                key: _stockKeys[index],
                ticker: data[index],
                history: () { historyPage(data[index]); },
                buy: buy,
                sell: sell
            );
          }
      ),
    );
  }

  dynamic profileWidget() {
    List<Stock> data = widget.stocks!;

    return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context,index) {
            return ProfileStockWidget(
                key: _profileKeys[index],
                s: data[index],
                buy: buy,
                sell: sell,
                history: () {} //TODO transaction history
            );
          }
      );
  }

  @override
  Widget build(BuildContext context) {
      if(widget.tickers != null) {
        return stocksWidget();
      }else {
        return profileWidget();
      }
  }

}