class Stock {
  final String userId;
  final String ticker;
  final String name;
  final double invested;
  final double stocks;

  Stock({required this.userId,required this.ticker,required this.name,this.stocks = 0,this.invested = 0});

  Stock.empty(this.userId,this.ticker,this.name) : stocks=0.00000,invested= 0.00;

  Stock copyWith({double? stocks,double? invested}) {
    return Stock(userId: userId,
                  ticker: ticker,
                  name: name,
                  stocks: stocks??this.stocks,
                  invested: invested??this.invested,
    );
  }

}