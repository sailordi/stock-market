import 'package:flutter/material.dart';
import 'package:stock_market/widgets/buttonWidget.dart';

class StockWidget extends StatelessWidget {
  final String ticker;
  final double price;
  final void Function()? buy;
  final void Function()? sell;
  
  const StockWidget({super.key,required this.ticker,required this.price,required this.buy,required this.sell});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logos/${ticker}_Logo.png'),
                  fit: BoxFit.fill,
                )
            )
          ),
          const SizedBox(width: 20,),
          Text(ticker),
          const SizedBox(width: 10,),
          //StockButtonWidget (text: "Buy: $price",tap:}),
          const SizedBox(width: 10,),
          //StockButtonWidget (text: "Sell: $price",tap:}),
          const SizedBox(height: 70,),
        ]
    );
  }
}