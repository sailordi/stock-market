import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/state/buySellState.dart';
import 'package:stock_market/widgets/profileStockWidget.dart';
import 'package:stock_market/widgets/stockWidget.dart';

import '../helper/helper.dart';
import '../managers/userManager.dart';
import '../models/appInfo.dart';
import '../models/stock.dart';

class StockListWidget extends ConsumerStatefulWidget {
  final List<String>? tickers;
  final List<Stock>? stocks;

  const StockListWidget({super.key,this.tickers,this.stocks});

  @override
  BuySellConsumerState<ConsumerStatefulWidget> createState() => _StockListWidgetState();

}

class _StockListWidgetState extends BuySellConsumerState<StockListWidget> with WidgetsBindingObserver {
  late Timer _timer;
  late List<GlobalKey<StockWidgetState> > _stockKeys;
  late List<GlobalKey<ProfileStockWidgetState> > _profileKeys;

  @override
  void initState() {
    super.initState();

    if(widget.tickers != null) {
      _profileKeys = [];
      _stockKeys = List.generate(widget.tickers!.length, (index) => GlobalKey<StockWidgetState>() );

      _timer = Timer.periodic(const Duration(milliseconds: REFRESH_TIME), (timer) {
        buySellWidgetState.currentState?.getPrice();
        for (var key in _stockKeys) {
          key.currentState?.getPrice();
        }

      });
    }
    else {
      _stockKeys = [];
      _profileKeys = List.generate(widget.stocks!.length, (index) => GlobalKey<ProfileStockWidgetState>() );

      _timer = Timer.periodic(const Duration(milliseconds: REFRESH_TIME), (timer) {
        buySellWidgetState.currentState?.getPrice();
        for (var key in _profileKeys) {
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

  void stockTransactionHistory(Stock s,double price) {
    ref.read(userManager.notifier).selectStock(s,price);

    Navigator.pushNamed(context,
        "/stockTransactions"
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
                history: () { Helper.stockHistoryPage(context,data[index]); },
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
                history: () { stockTransactionHistory(data[index],_profileKeys[index].currentState!.price); }
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