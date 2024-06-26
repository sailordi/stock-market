import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/models/userData.dart';

import '../../helper/helper.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/stockListWidget.dart';
import '../../managers/userManager.dart';
import '../../models/appInfo.dart';

class StocksView extends ConsumerStatefulWidget {
  const StocksView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StocksViewState();
}

class _StocksViewState extends ConsumerState<StocksView> {
  late StockListWidget w;

  @override
  void initState() {
    super.initState();

    w = StockListWidget(tickers: Stocks.keys.toList(),);
  }

  dynamic userData() {
    final uM = ref.watch(userManager);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Balance: ${Helper.formatCurrency(uM.data.balance)}",
            style: const TextStyle(fontSize: 20),
        ),
        Text("Invested: ${Helper.formatCurrency(uM.data.invested)}",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Stock market: stocks"),
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder<void> (
        future: ref.read(userManager.notifier).loadData(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text("Error: This is bad -> ${snapshot.error}"),
            );  
          }
          return  Column(
            children: [
              w,
              userData()
            ],
          );
        }
      )
    );
  }

}
