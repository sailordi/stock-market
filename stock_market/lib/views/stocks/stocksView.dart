import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/widgets/buySellWidget.dart';
import 'package:stock_market/widgets/stockListWidget.dart';

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
  late StockListWidget w;

  @override
  void initState() {
    super.initState();

    w = StockListWidget(tickers: Stocks.keys.toList(),);
  }


  dynamic userData() {
    final data = ref.watch(userManager);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Balance: ${Helper.formatCurrency(data.balance)}",
            style: const TextStyle(fontSize: 20),
        ),
        Text("Invested: ${Helper.formatCurrency(data.invested)}",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Stock market: stocks"),
      ),
      body: Column(
        children: [
          w,
          userData()
        ],
      )
    );
  }

}
