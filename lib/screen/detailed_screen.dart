import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/capcoin.dart';
import '../model/chart_data.dart';
import '../price_chart.dart';
import '../services/capcoin_api_service.dart';
import '../services/favorite_service.dart';
class CoinDetailScreen extends StatefulWidget {
  final CryptoCoin coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  String _selectedTimeframe = '24h';
  List<ChartData> _chartData = [];
  bool _isLoadingChart = true;
  CryptoCoin? _detailedCoin;

  final List<String> timeframes = ['1m', '20m', '1h', '3h', '24h'];

  @override
  void initState() {
    super.initState();
    _loadCoinDetails();
    _loadChartData();
  }

  Future<void> _loadCoinDetails() async {
    try {
      final coin = await CryptoApiService.fetchCoinDetails(widget.coin.id);
      setState(() {
        _detailedCoin = coin;
      });
    } catch (e) {
      print('Error loading coin details: $e');
    }
  }

  Future<void> _loadChartData() async {
    setState(() {
      _isLoadingChart = true;
    });

    try {
      final data = await CryptoApiService.fetchChartData(widget.coin.id, _selectedTimeframe);
      setState(() {
        _chartData = data;
        _isLoadingChart = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingChart = false;
      });
      print('Error loading chart: $e');
    }
  }

  void _changeTimeframe(String timeframe) {
    setState(() {
      _selectedTimeframe = timeframe;
    });
    _loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final isFavorite = favoritesService.isFavorite(widget.coin.id);
    final displayCoin = _detailedCoin ?? widget.coin;

    final priceFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final largeNumberFormat = NumberFormat.compact();
    final isPositive = displayCoin.priceChangePercentage24h >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(displayCoin.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              favoritesService.toggleFavorite(displayCoin);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coin Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: displayCoin.image,
                    width: 80,
                    height: 80,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error, size: 80),
                  ),
                  SizedBox(height: 16),
                  Text(
                    displayCoin.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    displayCoin.symbol,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    priceFormat.format(displayCoin.currentPrice),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${displayCoin.priceChangePercentage24h.toStringAsFixed(2)}% (24h)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Timeframe Selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Chart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: timeframes.map((timeframe) {
                        final isSelected = _selectedTimeframe == timeframe;
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(timeframe.toUpperCase()),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                _changeTimeframe(timeframe);
                              }
                            },
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Chart
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoadingChart
                  ? Container(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              )
                  : PriceChart(
                chartData: _chartData,
                timeframe: _selectedTimeframe,
              ),
            ),

            SizedBox(height: 24),

            // Market Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  if (displayCoin.high24h != null)
                    _buildStatCard(
                      '24h High',
                      priceFormat.format(displayCoin.high24h),
                      Icons.arrow_upward,
                    ),
                  SizedBox(height: 12),
                  if (displayCoin.low24h != null)
                    _buildStatCard(
                      '24h Low',
                      priceFormat.format(displayCoin.low24h),
                      Icons.arrow_downward,
                    ),
                  SizedBox(height: 12),
                  if (displayCoin.marketCapRank != null)
                    _buildStatCard(
                      'Market Cap Rank',
                      '#${displayCoin.marketCapRank}',
                      Icons.emoji_events,
                    ),
                ],
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}