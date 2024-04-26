import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/helper/helper.dart';
import 'package:tab_container/tab_container.dart';

import '../../managers/userManager.dart';
import '../../models/stock.dart';
import '../../models/userData.dart';
import '../../widgets/stockListWidget.dart';

class WalletView extends ConsumerStatefulWidget {
  const WalletView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  dynamic userInfoSection(UserData u) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Username: ${u.name}",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Email: ${u.email}",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  dynamic userWalletData(UserData u) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Balance: ${Helper.formatCurrency(u.balance)}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Invested: ${Helper.formatCurrency(u.invested)}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        )
      ],
    );
  }

  dynamic activeStocks(List<Stock> s) {
    if(s.isEmpty) {
      return const SizedBox();
    }
    return  StockListWidget(stocks: s,);
  }

  dynamic inactiveStocks(List<Stock> s) {
    if (s.isEmpty) {
      return const SizedBox();
    }
    return StockListWidget(stocks: s,);
  }

  dynamic tabContainer(BuildContext context,List<Stock> active,List<Stock> inactive) {
    return TabContainer(
      controller: _tabController,
      tabEdge: TabEdge.top,
      tabsStart: 0.1,
      tabsEnd: 0.9,
      tabMaxLength: 100,
      borderRadius: BorderRadius.circular(10),
      tabBorderRadius: BorderRadius.circular(10),
      childPadding: const EdgeInsets.all(20.0),
      selectedTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 15.0,
      ),
      unselectedTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
      ),
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primary,
      ],
      tabs: const [
        Text('Active'),
        Text('Inactive'),
      ],
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height-320,
          child: activeStocks(active)
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height-320,
            child: inactiveStocks(inactive)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final uM = ref.watch(userManager);
    final tickers = uM.stocks.keys;
    List<Stock> active = [];
    List<Stock> inactive = [];

    if(tickers.isNotEmpty) {
      active = uM.stocks.values.where((s) => s.stocks > 0).toList();
      inactive = uM.stocks.values.where((s) => s.stocks <= 0).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Stock market: ${uM.data.name}'s wallet"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          userInfoSection(uM.data),
          userWalletData(uM.data),
          const SizedBox(height: 20,),
          tabContainer(context,active,inactive)
        ],
      ),
    );

  }

}