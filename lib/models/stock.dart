class Stock {
  final String userId;
  final String ticker;
  final String name;
  final double invested;
  final double stocks;
  final bool tmp;

  Stock({required this.userId,required this.ticker,required this.name,this.stocks = 0,this.invested = 0,this.tmp = false});

  Stock.empty(this.userId,this.ticker,this.name,{this.tmp = false}) : stocks=0.00000,invested= 0.00;

  Stock copyWith({double? stocks,double? invested,bool? tmp}) {
    return Stock(userId: userId,
                  ticker: ticker,
                  name: name,
                  stocks: stocks??this.stocks,
                  invested: invested??this.invested,
                  tmp: tmp??this.tmp
    );
  }

}