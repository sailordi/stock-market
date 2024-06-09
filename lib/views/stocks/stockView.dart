import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/models/stockHistoryData.dart';
import 'package:stock_market/widgets/chartWidget.dart';

import '../../adapters/downloadAdapter.dart';
import '../../helper/helper.dart';
import '../../managers/stockPriceManager.dart';
import '../../managers/userManager.dart';
import '../../models/stock.dart';
import '../../state/buySellState.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/logoWidget.dart';

class StockView extends ConsumerStatefulWidget {
  const StockView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StockViewState();
}

class _StockViewState extends BuySellConsumerState<StockView> {
  final DownloadAdapter _downloadA = DownloadAdapter();
  late Stock stock = Stock.empty("","","");
  late UserManager uM;
  late double  price = 0.00;
  late String ticker = "";
  List<StockHistoryData> data = [];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final m = ref.watch(userManager);
      final stockPrices = ref.watch(stockPriceManager);

      stock = m.selectedStock!;
      ticker = stock.ticker;
      price = stockPrices[ticker]!;

      getData();

    });

  }

  dynamic generalData(Stock s,String ticker) {
    if(s.tmp == true) {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticker),
              Text("Name: ${s.name}",),
              const SizedBox(height: 3,),
              LogoWidget(ticker: ticker, history: () { },tickerOverLogo: false,height: 90,),
              const SizedBox(height: 5,),
            ],
          ),
          const SizedBox(width: 10,),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticker),
            Text("Name: ${s.name}",),
            const SizedBox(height: 3,),
            LogoWidget(ticker: ticker, history: () {  },tickerOverLogo: false,height: 90,),
            const SizedBox(height: 5,),
            Text("Stocks: ${s.stocks}"),
            const SizedBox(height: 5,),
            Text("Invested: ${Helper.formatCurrency(s.invested)}"),
          ],
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  void getData() async {
    data = await _downloadA.getPriceHistory(ticker);
  }

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 160.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Stock market history: $ticker"),
      ),
      body: Column(
        children: [
          generalData(stock,ticker),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 5,),
              StockButtonWidget.buy(text: Helper.formatCurrency(price), tap: () { buy(ticker,price); },width: buttonWidth,),
              StockButtonWidget.sell(text: Helper.formatCurrency(price), tap: () { sell(ticker,price,stock.stocks); },width: buttonWidth,),
              const SizedBox(width: 10,),
            ],
          ),
          const SizedBox(height: 20,),
          ChartWidget(data: data)
        ],
      )
    );

  }

}