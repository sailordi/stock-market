import 'package:flutter/material.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/widgets/buttonWidget.dart';

import '../helper/helper.dart';

class BuySellWidget extends StatefulWidget {
  final MyAction action;
  final String ticker;
  final double stocks;
  final void Function(double,String)? tap;

  const BuySellWidget({super.key,required this.action,required this.ticker,this.stocks = 0.0,required this.tap});

  @override
  State<BuySellWidget> createState() => BuySellWidgetState();

}

class BuySellWidgetState extends State<BuySellWidget> {
  final TextEditingController _controller = TextEditingController();
  double price = 0.0;

  @override
  void initState() {
    super.initState();

    getPrice();

  }

  String formatNumber() {
    String ret = price.toStringAsFixed(2);

    return ret;
  }

  Future<void> getPrice() async {
    var data = await Helper.stockPrice(widget.ticker);

    if (mounted) {
      setState(() {
        price = data["rate"];
      });
    }

  }

  String title() {
    String ret = '';

    if(widget.action == MyAction.buy) {
      ret = "Buy ${widget.ticker}\nfor\n${formatNumber()}\$ per stock";
    }
    else {
      ret = "Sell ${widget.ticker}\nfor\n${formatNumber()}\$ per stock";
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title(),
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