import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adapters/downloadAdapter.dart';
import '../models/appInfo.dart';

typedef TickersPrices = Map<String, double>;

class StockPriceManager extends StateNotifier<TickersPrices> {
  late Timer? _timer;
  final DownloadAdapter _downloadA = DownloadAdapter();

  StockPriceManager(super.initialStocks) {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: REFRESH_TIME), (timer) {
      _fetchPrices();
    });
  }

  Future<void> _fetchPrices() async {
    final symbols = state.keys.toList();

    TickersPrices updatedStocks = {};

    for (var symbol in symbols) {
      await _downloadA.getPrice(symbol,(String ticker,double price) {
        updatedStocks[ticker] = price;
      });
    }

    state = updatedStocks;
  }

}

final stockPriceManager = StateNotifierProvider<StockPriceManager,TickersPrices>((ref) {
  // Provide the initial stock symbols with default prices (e.g., 0.0)
  final keys = Stocks.keys;
  TickersPrices init = {};

  for(final key in keys) {
    init[key] = 0.00;
  }

  return StockPriceManager(init);
});