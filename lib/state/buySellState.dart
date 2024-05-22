import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    var message = await ref.read(userManager.notifier).buy(t);

    if(mounted) {
      Helper.messageToUser(message.$2,context);
    }
    if(message.$1 && mounted) {
      Navigator.pop(context);
    }

  }

  void preformSell(String id,String ticker,double price,double amount) async {
    MyTransaction t = MyTransaction.sell(
        userId:id,
        ticker: ticker,
        amount: amount,
        price: price,
        stocks: amount
    );

    var message = await ref.read(userManager.notifier).sell(t);

    if(mounted) {
      Helper.messageToUser(message.$2,context);
    }
    if(message.$1 && mounted) {
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
            return;
          }
          double am = double.parse(amount);

          if(am <= 0) {
            Helper.messageToUser("Amount cant be equal or less than 0", context);
            return;
          }

          final data = ref.watch(userManager).data;


          preformBuy(data.id!,ticker,price,am);

        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );
  }

  void sell(String ticker,double price,double stocks) {
    BuySellWidget w = BuySellWidget(
        key: buySellWidgetState,
        action: MyAction.sell,
        ticker: ticker,
        stocks:stocks,
        tap: (double price,String amount) {
          if(amount.isEmpty) {
            Helper.messageToUser("No amount entered", context);
            return;
          }
          double am;
          RegExp percentage = RegExp(r'^[1-9][0-9]?%$|^100%$');
          RegExp numbers = RegExp(r'^\d+$');

          if(percentage.hasMatch(amount) ) {
            amount = amount.replaceFirst("%", "");
            am = double.parse(amount);

            if(am > 100 || am < 1) {
              Helper.messageToUser("% amount entered can not be more than 100% and not less than 1%", context);
              return;
            }
            am = stocks * (am/100);
          }else if(numbers.hasMatch(amount) ) {
            am = double.parse(amount);
            if(am < 1) {
              Helper.messageToUser("Amount cant be equal or less than 0", context);
              return;
            }
          }else {
            Helper.messageToUser("Amount is not a valid number or number followed by %", context);
            return;
          }

          final data = ref.watch(userManager).data;

          preformSell(data.id!,ticker,price,am);

        }
    );

    showDialog(context: context,
      builder: (context) => w,
    );

  }

}
