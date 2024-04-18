import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/widgets/buttonWidget.dart';

import '../models/myTransaction.dart';
import '../models/stock.dart';

class ProfileStockWidget extends StatefulWidget {
  final Stock s;
  final void Function(String ticker,double price)? buy;
  final void Function(String ticker,double price)? sell;
  final void Function()? history;

  const ProfileStockWidget({super.key,required this.s,required this.history,required this.buy,required this.sell});

  @override
  State<ProfileStockWidget> createState() => ProfileStockWidgetState();

}

class ProfileStockWidgetState extends State<ProfileStockWidget> {
  double price = 0.0;

  @override
  void initState() {
    super.initState();

    getPrice();

  }

  Future<void> getPrice() async {
    var data = await Helper.stockPrice(widget.s.ticker);

    if (mounted) {
      setState(() {
        price = data["rate"];
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    double width = 100.0;

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: widget.history,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.s.ticker),
                Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logos/${widget.s.ticker}_Logo.png'),
                          fit: BoxFit.fill,
                        )
                    )
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(" Stocks: ${widget.s.stocks}"),
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