import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/models/stock.dart';

import '../../helper/helper.dart';
import '../../managers/userManager.dart';

import '../../models/appInfo.dart';
import '../../state/stockPriceState.dart';

class StockTransactionHistoryView extends ConsumerStatefulWidget{
  const StockTransactionHistoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StockTransactionHistoryViewState();

}

class _StockTransactionHistoryViewState extends StockPriceConsumerState<StockTransactionHistoryView> with WidgetsBindingObserver {
  Stock? s;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: REFRESH_TIME), (timer) {
      getPrice();
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

  @override
  Widget build(BuildContext context) {
    s = ModalRoute.of(context)!.settings.arguments as Stock;
    final data = ref.watch(userManager);

    setTicker(s!.ticker);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("${s!.ticker} transaction data"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ticker: ${s!.ticker}"),
              Text("Name: ${s!.name}"),
            ],
          ),
          Row(
            children: [
              Text("Stocks: ${s!.stocks}"),
              Text("Invested: ${Helper.formatCurrency(s!.invested)}"),
              Text("Current price: ${Helper.formatCurrency(price)}"),
            ],
          )
        ],
      ),
    );
  }

}