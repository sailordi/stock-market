import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/state/buySellState.dart';
import 'package:stock_market/widgets/profileStockWidget.dart';
import 'package:stock_market/widgets/stockWidget.dart';

import '../helper/helper.dart';
import '../helper/routes.dart';
import '../managers/userManager.dart';
import '../models/stock.dart';

class StockListWidget extends ConsumerStatefulWidget {
  final List<String>? tickers;
  final List<Stock>? stocks;

  const StockListWidget({super.key,this.tickers,this.stocks});

  @override
  BuySellConsumerState<ConsumerStatefulWidget> createState() => _StockListWidgetState();

}

class _StockListWidgetState extends BuySellConsumerState<StockListWidget> {

  @override
  void initState() {
    super.initState();
  }

  void stockTransactionHistory(String ticker) async {
    await ref.read(userManager.notifier).selectStock(ticker);

    if(mounted) {
      Navigator.pushNamed(context,Routes.stocksTransactions() );
    }

  }

  void stockHistoryPage(String ticker) async {
    await ref.read(userManager.notifier).selectStockHistory(ticker);

    if(mounted) {
      Navigator.pushNamed(context,Routes.stockHistory() );
    }

  }

  dynamic stocksWidget() {
    List<String> data = widget.tickers!;
    var uM = ref.watch(userManager);
    var stocks = uM.stocks;

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context,index) {
            return StockWidget(
                ticker: data[index],
                history: () { stockHistoryPage(data[index]); },
                buy: buy,
                sell: sell,
                stocks: (stocks.containsKey(data[index]) ) ? stocks[data[index]]!.stocks : 0.00
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
                s: data[index],
                buy: buy,
                sell: sell,
                history: () { stockTransactionHistory(data[index].ticker); }
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