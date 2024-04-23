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

          MyTransaction t = MyTransaction.buy(
              userId:data.id!,
              ticker: ticker,
              amount: am,
              price: price,
              stocks: am/price
          );

          String message = ref.read(userManager.notifier).buy(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
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
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          MyTransaction t = MyTransaction.sell(
              userId:data.id!,
              ticker: ticker,
              amount: am*price,
              price: price,
              stocks: am
          );

          String message = ref.read(userManager.notifier).sell(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }

}

abstract class BuySellWitTickerConsumerState<T extends ConsumerStatefulWidget> extends StockPriceConsumerState<T> {
  final GlobalKey<BuySellWidgetState> buySellWidgetState = GlobalKey<BuySellWidgetState>();

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

          MyTransaction t = MyTransaction.buy(
              userId:data.id!,
              ticker: ticker,
              amount: am,
              price: price,
              stocks: am/price
          );

          String message = ref.read(userManager.notifier).buy(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
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
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            Navigator.pop(context);
            return;
          }
          final data = ref.watch(userManager).data;
          double am = double.parse(amount);

          MyTransaction t = MyTransaction.sell(
              userId:data.id!,
              ticker: ticker,
              amount: am*price,
              price: price,
              stocks: am
          );

          String message = ref.read(userManager.notifier).sell(t);

          Helper.messageToUser(message,context);
          Navigator.pop(context);
        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }
}
