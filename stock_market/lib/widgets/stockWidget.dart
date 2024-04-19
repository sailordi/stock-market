import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';

import '../state/stockPriceState.dart';

class StockWidget extends StatefulWidget {
  final String ticker;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price)? sell;
  final void Function()? history;
  
  const StockWidget({super.key,required this.ticker,required this.history,required this.buy,required this.sell});

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
          GestureDetector(
            onTap: widget.history,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.ticker),
                Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logos/${widget.ticker}_Logo.png'),
                          fit: BoxFit.fill,
                        )
                    )
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StockButtonWidget.buy(text: Helper.formatCurrency(price),tap:() { widget.buy!(widget.ticker,price); }  ),
              const SizedBox(width: 10,),
              StockButtonWidget.sell(text: Helper.formatCurrency(price),tap:() { widget.sell!(widget.ticker,price); } ),
              const SizedBox(width: 10,)
            ],
          ),
          const SizedBox(height: 90,),
        ]
    );
  }
}