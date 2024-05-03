import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';
import 'package:stock_market/widgets/logoWidget.dart';

import '../state/stockPriceState.dart';

class StockWidget extends StatefulWidget {
  final String ticker;
  final double stocks;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price,double stocks)? sell;
  final void Function()? history;
  
  const StockWidget({super.key,required this.ticker,required this.stocks,required this.history,required this.buy,required this.sell});

  @override
  State<StockWidget> createState() => StockWidgetState(ticker: ticker);

}

class StockWidgetState extends StockPriceState<StockWidget> {

  StockWidgetState({required super.ticker});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          LogoWidget(ticker: ticker, history: widget.history),
          const SizedBox(width: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StockButtonWidget.buy(text: Helper.formatCurrency(price),tap:() { widget.buy!(widget.ticker,price); }  ),
              const SizedBox(width: 10,),
              StockButtonWidget.sell(text: Helper.formatCurrency(price),tap:() { widget.sell!(widget.ticker,price,widget.stocks); } ),
              const SizedBox(width: 10,)
            ],
          ),
          const SizedBox(height: 90,),
        ]
    );
  }
}