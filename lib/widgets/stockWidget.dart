import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';
import 'package:stock_market/widgets/logoWidget.dart';

import '../managers/stockPriceManager.dart';

class StockWidget extends ConsumerStatefulWidget {
  final String ticker;
  final double stocks;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price,double stocks)? sell;
  final void Function()? history;
  
  const StockWidget({super.key,required this.ticker,required this.stocks,required this.history,required this.buy,required this.sell});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StockWidgetState();

}

class StockWidgetState extends ConsumerState<StockWidget> {

  StockWidgetState();

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stockPriceManager);
    final ticker = widget.ticker;

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          LogoWidget(ticker: ticker, history: widget.history),
          const SizedBox(width: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StockButtonWidget.buy(text: Helper.formatCurrency(stocks[ticker]!),tap:() { widget.buy!(widget.ticker,stocks[ticker]!); }  ),
              const SizedBox(width: 10,),
              StockButtonWidget.sell(text: Helper.formatCurrency(stocks[ticker]!),tap:() { widget.sell!(widget.ticker,stocks[ticker]!,widget.stocks); } ),
              const SizedBox(width: 10,)
            ],
          ),
          const SizedBox(height: 90,),
        ]
    );
  }
}