import 'package:flutter/material.dart';
import 'package:stock_market/models/myTransaction.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? tap;

  const ButtonWidget({super.key,required this.text,required this.tap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child:GestureDetector(
            onTap: tap,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(25),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)
              ),
            ),
          )
        )
      ]
    );
  }

}

class StockButtonWidget  extends StatelessWidget {
  final MyAction action;
  final String text;
  final void Function()? tap;

  const StockButtonWidget({super.key,required this.action,required this.text, required this.tap});

  @override
  Widget build(BuildContext context) {
    Color c = (action == MyAction.buy) ? Colors.red : Colors.green;

    return GestureDetector(
          onTap: tap,
          child: Container(
            width: 120.0,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(25),
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)
            ),
          ),
      );
  }

}