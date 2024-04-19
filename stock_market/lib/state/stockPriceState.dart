import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper/helper.dart';

abstract class StockPriceState<T extends StatefulWidget> extends State<T> {
  final String ticker;
  double price = 0.00;

  StockPriceState({required this.ticker});

  @override
  void initState() {
    super.initState();
    getPrice();
  }

  void updatePrice(double p) {
    if (mounted) {
      setState(() {
        price = p;
      });
    }
  }

  Future<void> getPrice() async {
    await Helper.getPrice(ticker,updatePrice);
  }

  @override
  Widget build(BuildContext context);

}

abstract class StockPriceConsumerState<T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  String ticker;
  double price = 0.00;

  StockPriceConsumerState({this.ticker = ""});

  Future<void> setTicker(String ticker) async {
    if (mounted) {
      setState(() {
        this.ticker = ticker;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPrice();
  }

  void updatePrice(double p) {
    if (mounted) {
      setState(() {
        price = p;
      });
    }
  }

  Future<void> getPrice() async {
    if(ticker.isEmpty) { return; }
    await Helper.getPrice(ticker,updatePrice);
  }

  @override
  Widget build(BuildContext context);

}