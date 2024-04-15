import 'package:flutter/material.dart';

import '../../models/appInfo.dart';
import '../../widgets/stockWidget.dart';

class StocksView extends StatefulWidget {
  const StocksView({super.key});

  @override
  State<StocksView> createState() => _StocksViewState();
}

class _StocksViewState extends State<StocksView> {

  @override
  void initState() {
    super.initState();
  }

  void historyPage(String ticker) {
    Navigator.pushNamed(context,
        arguments: ticker,
        "/stock"
    );
  }

  void buy(String ticker,double price) {

  }

  void sell(String ticker,double price) {

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
            return StockWidget(ticker: tickers[index],
              history: () { historyPage(tickers[index]); },
              buy: () {
                buy(tickers[index],0.00);
              },
              sell: () {
                sell(tickers[index],0.00);
              }
            );
          }
      ),
    );
  }

}