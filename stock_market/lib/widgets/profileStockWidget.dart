import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';
import 'package:stock_market/widgets/logoWidget.dart';

import '../models/stock.dart';
import '../state/stockPriceState.dart';

class ProfileStockWidget extends StatefulWidget {
  final Stock s;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price)? sell;
  final void Function()? history;

  const ProfileStockWidget({super.key,required this.s,required this.history,required this.buy,required this.sell});

  @override
  State<ProfileStockWidget> createState() => ProfileStockWidgetState(ticker: s.ticker);

}

class ProfileStockWidgetState extends StockPriceState<ProfileStockWidget> {

  ProfileStockWidgetState({required super.ticker});

  @override
  Widget build(BuildContext context) {
    double width = 100.0;

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
                  StockButtonWidget.buy(text: Helper.formatCurrency(price),tap:() { widget.buy!(widget.s.ticker,price); },width: width,),
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
                  StockButtonWidget.sell(text: Helper.formatCurrency(price),tap:() { widget.buy!(widget.s.ticker,price); },width: width,),
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