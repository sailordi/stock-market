import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/myTransaction.dart';
import '../widgets/buttonWidget.dart';
import '../helper/helper.dart';
import '../managers/stockPriceManager.dart';

class BuySellWidget extends ConsumerStatefulWidget  {
  final MyAction action;
  final String ticker;
  final double stocks;
  final void Function(double,String)? tap;

  const BuySellWidget({super.key,required this.action,required this.ticker,this.stocks = 0.0,required this.tap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuySellWidgetState();

}

class _BuySellWidgetState extends ConsumerState<BuySellWidget> {
  final TextEditingController _controller = TextEditingController();

  String title(double price) {
    String ret = '';

    if(widget.action == MyAction.buy) {
      ret = "Buy ${widget.ticker}\nfor\n${Helper.formatCurrency(price)} per stock";
    }
    else {
      ret = "Sell ${widget.ticker}\nfor\n${Helper.formatCurrency(price)} per stock";
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stockPriceManager);
    var price = stocks[widget.ticker];

    return AlertDialog(
      title: Text(title(price!),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (widget.action == MyAction.sell) ? Text("You have ${widget.stocks} stocks") : const SizedBox(),
            (widget.action == MyAction.sell) ? const SizedBox(height: 20,) : const SizedBox(),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: (widget.action == MyAction.buy) ?'Enter amount to spend' : "Enter amount to sell or % to sell"
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWidget(
                text:(widget.action == MyAction.buy) ? "Buy" : "Sell",
                tap: () { widget.tap!(price,_controller.text); }
            ),
            const SizedBox(width: 20,),
            ButtonWidget(
                text:"Cancel",
                tap: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
        )
      ],
    );

  }

}