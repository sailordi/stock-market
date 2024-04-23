import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/helper/helper.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/widgets/logoWidget.dart';

class StockTransactionWidget extends StatelessWidget {
  final MyTransaction t;

  const StockTransactionWidget({super.key,required this.t});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 10,),
        Expanded(child:Text( (t.action == MyAction.buy) ? "Buy":"Sell",
          textAlign: TextAlign.center,
        ) ),
        Expanded(child:Text(Helper.formatTimeStamp(t.timeStamp),
          textAlign: TextAlign.center,
        ) ),
        Expanded(child:Text("${(t.action == MyAction.buy) ? "": "-"}${t.stocks}",
          textAlign: TextAlign.center,
        ),),
        Expanded(child:Text(Helper.formatCurrency(t.price),
          textAlign: TextAlign.center,
        ) ),
        Expanded(child:Text("${(t.action == MyAction.buy) ? "-": ""}${Helper.formatCurrency(t.amount)}",
          textAlign: TextAlign.center,
        ) ),
        const SizedBox(width: 10,),
      ],
    );
  }


}
