import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';
import 'package:stock_market/widgets/logoWidget.dart';

import '../managers/stockPriceManager.dart';
import '../models/stock.dart';

class ProfileStockWidget extends ConsumerStatefulWidget {
  final Stock s;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price,double stocks)? sell;
  final void Function()? history;

  const ProfileStockWidget({super.key,required this.s,required this.history,required this.buy,required this.sell});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileStockWidgetState();

}

class ProfileStockWidgetState extends ConsumerState<ProfileStockWidget> {

  ProfileStockWidgetState();

  @override
  Widget build(BuildContext context) {
    double width = 100.0;
    final stocks = ref.watch(stockPriceManager);
    final ticker = widget.s.ticker;

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          LogoWidget(ticker: ticker, history: widget.history),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(" Stocks: ${widget.s.stocks.toStringAsFixed(2)}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StockButtonWidget.buy(text: Helper.formatCurrency(stocks[ticker]!),tap:() { widget.buy!(widget.s.ticker,stocks[ticker]!); },width: width,),
                  const SizedBox(width: 10,),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(" Invested: ${widget.s.invested}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StockButtonWidget.sell(text: Helper.formatCurrency(stocks[ticker]!),tap:() { widget.sell!(widget.s.ticker,stocks[ticker]!,widget.s.stocks); },width: width,),
                  const SizedBox(width: 10,),
                ],
              ),
            ],
          ),
          const SizedBox(height: 90,),
        ]
    );
  }
}