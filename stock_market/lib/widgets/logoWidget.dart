import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final void Function()? history;
  final String ticker;
  final bool tickerOverLogo;
  final double width;
  final double height;

  const LogoWidget({super.key,required this.ticker,required this.history,this.tickerOverLogo = true,this.width = 130,this.height = 50});

  @override
  Widget build(BuildContext context) {
    if(tickerOverLogo) {
      return GestureDetector(
        onTap: history,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ticker),
            Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logos/${ticker}_Logo.png'),
                      fit: BoxFit.fill,
                    )
                )
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: history,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logos/${ticker}_Logo.png'),
                    fit: BoxFit.fill,
                  )
              )
          ),
        ],
      ),
    );

  }

}