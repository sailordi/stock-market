import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/models/userModel.dart';
import 'package:stock_market/widgets/logoWidget.dart';
import 'package:stock_market/widgets/transactionWidget.dart';

import '../../models/stock.dart';
import '../../widgets/buttonWidget.dart';
import '../../helper/helper.dart';
import '../../managers/userManager.dart';
import '../../models/appInfo.dart';
import '../../state/buySellState.dart';
import '../../widgets/stockWidget.dart';

class StockTransactionHistoryView extends ConsumerStatefulWidget{
  const StockTransactionHistoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StockTransactionHistoryViewState();

}

class _StockTransactionHistoryViewState extends BuySellWitTickerConsumerState<StockTransactionHistoryView> {
  late Timer _timer;
  late Stock stock = Stock.empty("","","");
  late TransactionList transactions = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final m = ref.watch(userManager);
      stock = m.selectedStock!;
      transactions = m.transactions;

      updatePrice(m.stockPrice);

      stockData(stock.ticker);

      _timer = Timer.periodic(const Duration(milliseconds: REFRESH_TIME), (timer) {
        buySellWidgetState.currentState?.getPrice();
        getPrice();
      });

    });

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> stockData(String ticker) async {
    await setTicker(ticker);
  }

  dynamic transactionList(TransactionList  data) {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context,index) {
            return StockTransactionWidget(t: data[index],);
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 160.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${stock.ticker} transaction data"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticker),
                  Text("Name: ${stock.name}",),
                  const SizedBox(height: 3,),
                  LogoWidget(ticker: ticker, history: () { Helper.stockHistoryPage(context, ticker); },tickerOverLogo: false,height: 90,),
                  const SizedBox(height: 5,),
                  Text("Stocks: ${stock.stocks}"),
                  const SizedBox(height: 5,),
                  Text("Invested: ${Helper.formatCurrency(stock.invested)}"),
                ],
              ),
              const SizedBox(width: 10,),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 5,),
              StockButtonWidget.buy(text: Helper.formatCurrency(price), tap: () { buy(ticker,price); },width: buttonWidth,),
              StockButtonWidget.sell(text: Helper.formatCurrency(price), tap: () { buy(ticker,price); },width: buttonWidth,),
              const SizedBox(width: 10,),
            ],
          ),
          const SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child:   const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10,),
                Expanded(child: Text("Type",
                  textAlign: TextAlign.center,
                ) ),
                Expanded(child: Text("DateTime",
                  textAlign: TextAlign.center,
                ) ),
                Expanded(child: Text("Stocks",
                  textAlign: TextAlign.center,
                ) ),
                Expanded(child: Text("Price",
                  textAlign: TextAlign.center,
                ) ),
                Expanded(child: Text("Amount",
                  textAlign: TextAlign.center,
                ) ),
                SizedBox(width: 10,),
              ],
            ),
          ),
          const SizedBox(height: 2,),
          transactionList(transactions)
        ],
      ),
    );
  }

}