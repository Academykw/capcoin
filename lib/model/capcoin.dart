class CryptoCoin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double previousPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final double? high24h;
  final double? low24h;
  final int? marketCapRank;

  CryptoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    double? previousPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    this.high24h,
    this.low24h,
    this.marketCapRank,
  }): previousPrice = previousPrice ?? currentPrice;

  // Calculate live price change percentage
  double get livePriceChangePercentage {
    if (previousPrice == 0) return 0;
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }

  // Check if price increased
  bool get isPriceIncreased => currentPrice >= previousPrice;

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      high24h: json['high_24h']?.toDouble(),
      low24h: json['low_24h']?.toDouble(),
      marketCapRank: json['market_cap_rank'],
    );
  }

  // Create updated coin with new price
  CryptoCoin copyWithNewPrice(double newPrice) {
    return CryptoCoin(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: newPrice,
      previousPrice: currentPrice,
      priceChangePercentage24h: priceChangePercentage24h,
      marketCap: marketCap,
      totalVolume: totalVolume,
      high24h: high24h,
      low24h: low24h,
      marketCapRank: marketCapRank,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap': marketCap,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'market_cap_rank': marketCapRank,
    };
  }
}
