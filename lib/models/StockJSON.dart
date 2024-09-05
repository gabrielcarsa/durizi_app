class Stock {
  final String symbol;
  final double regularMarketPrice;
  final double regularMarketChangePercent;
  final String logourl;

  Stock({
    required this.symbol,
    required this.regularMarketPrice,
    required this.regularMarketChangePercent,
    required this.logourl,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      regularMarketPrice: (json['regularMarketPrice'] ?? 0.0).toDouble(),
      regularMarketChangePercent: (json['regularMarketChangePercent'] ?? 0.0).toDouble(),
      logourl: json['logourl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'regularMarketPrice': regularMarketPrice,
    'regularMarketChangePercent': regularMarketChangePercent,
    'logourl': logourl,
  };
}
