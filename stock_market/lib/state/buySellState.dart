import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'stockPriceState.dart';
import '../helper/helper.dart';
import '../managers/userManager.dart';
import '../models/myTransaction.dart';
import '../widgets/buySellWidget.dart';

abstract class BuySellConsumerState<T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  final GlobalKey<BuySellWidgetState> buySellWidgetState = GlobalKey<BuySellWidgetState>();

  void preformBuy(String id,String ticker,double price,double amount) async {
    MyTransaction t = MyTransaction.buy(
        userId:id,
        ticker: ticker,
        amount: amount,
        price: price,
        stocks: amount/price
    );

    String message = await ref.read(userManager.notifier).buy(t);

    if(mounted) {
      Helper.messageToUser(message,context);
      Navigator.pop(context);
    }
  }

  void preformSell(String id,String ticker,double price,double amount) async {
    MyTransaction t = MyTransaction.sell(
        userId:id,
        ticker: ticker,
        amount: amount*price,
        price: price,
        stocks: amount
    );

    String message = await ref.read(userManager.notifier).sell(t);

    if(mounted) {
      Helper.messageToUser(message,context);
      Navigator.pop(context);
    }

  }

  void buy(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: buySellWidgetState,
        action: MyAction.buy,
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          preformBuy(data.id!,ticker,price,am);
        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }

  void sell(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: buySellWidgetState,
        action: MyAction.sell,
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          preformSell(data.id!,ticker,price,am);

        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }

}

abstract class BuySellWitTickerConsumerState<T extends ConsumerStatefulWidget> extends StockPriceConsumerState<T> {
  final GlobalKey<BuySellWidgetState> buySellWidgetState = GlobalKey<BuySellWidgetState>();

  void preformBuy(String id,String ticker,double price,double amount) async {
    MyTransaction t = MyTransaction.buy(
        userId:id,
        ticker: ticker,
        amount: amount,
        price: price,
        stocks: amount/price
    );

    String message = await ref.read(userManager.notifier).buy(t);

    if(mounted) {
      Helper.messageToUser(message,context);
      Navigator.pop(context);
    }
  }

  void preformSell(String id,String ticker,double price,double amount) async {
    MyTransaction t = MyTransaction.sell(
        userId:id,
        ticker: ticker,
        amount: amount*price,
        price: price,
        stocks: amount
    );

    String message = await ref.read(userManager.notifier).sell(t);

    if(mounted) {
      Helper.messageToUser(message,context);
      Navigator.pop(context);
    }

  }

  void buy(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: buySellWidgetState,
        action: MyAction.buy,
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          preformBuy(data.id!,ticker,price,am);
        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );
  }

  void sell(String ticker,double price) {
    BuySellWidget w = BuySellWidget(
        key: buySellWidgetState,
        action: MyAction.sell,
        ticker: ticker,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          preformSell(data.id!,ticker,price,am);

        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }

}
