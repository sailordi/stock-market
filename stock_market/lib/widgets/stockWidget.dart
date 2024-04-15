import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/widgets/buttonWidget.dart';

class StockWidget extends StatefulWidget {
  final String ticker;
  final void Function()? buy;
  final void Function()? sell;
  final void Function()? history;
  
  const StockWidget({super.key,required this.ticker,required this.history,required this.buy,required this.sell});

  @override
  State<StockWidget> createState() => _StockWidgetState();

}

class _StockWidgetState extends State<StockWidget> {
  double price = 0.0;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      getPrice();
    });

  }

  @override
  void dispose() {
    _timer?.cancel();  // Don't forget to cancel the timer to avoid memory leaks
    super.dispose();
  }

  Future<void> getPrice() async {
    var data = await Helper.stockPrice(widget.ticker);

    setState(() {
      price = data["rate"];
    });
  }

  String formatNumber() {
    String ret = price.toStringAsFixed(2);

    return ret;
  }

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
              StockButtonWidget (action: MyAction.buy,text: formatNumber(),tap:widget.buy),
              const SizedBox(width: 10,),
              StockButtonWidget (action: MyAction.sell,text: formatNumber(),tap:widget.sell),
              const SizedBox(width: 10,)
            ],
          ),
          const SizedBox(height: 90,),
        ]
    );
  }
}