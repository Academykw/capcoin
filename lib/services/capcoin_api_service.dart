
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/capcoin.dart';
import '../model/chart_data.dart';

class CryptoApiService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // Fetch list of coins with market data
  static Future<List<CryptoCoin>> fetchCoins() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoCoin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coins: $e');
    }
  }

  // Fetch detailed coin data
  static Future<CryptoCoin> fetchCoinDetails(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$coinId?localization=false&tickers=false&community_data=false&developer_data=false'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        return CryptoCoin(
          id: data['id'],
          symbol: (data['symbol'] ?? '').toUpperCase(),
          name: data['name'],
          image: data['image']['large'] ?? '',
          currentPrice: (data['market_data']['current_price']['usd'] ?? 0).toDouble(),
          priceChangePercentage24h: (data['market_data']['price_change_percentage_24h'] ?? 0).toDouble(),
          marketCap: (data['market_data']['market_cap']['usd'] ?? 0).toDouble(),
          totalVolume: (data['market_data']['total_volume']['usd'] ?? 0).toDouble(),
          high24h: data['market_data']['high_24h']['usd']?.toDouble(),
          low24h: data['market_data']['low_24h']['usd']?.toDouble(),
          marketCapRank: data['market_cap_rank'],
        );
      } else {
        throw Exception('Failed to load coin details');
      }
    } catch (e) {
      throw Exception('Error fetching coin details: $e');
    }
  }

  // Fetch chart data for different timeframes
  static Future<List<ChartData>> fetchChartData(String coinId, String timeframe) async {
    String days;

    switch (timeframe) {
      case '1m':
        days = '1';
        break;
      case '20m':
        days = '1';
        break;
      case '1h':
        days = '1';
        break;
      case '3h':
        days = '1';
        break;
      case '24h':
        days = '1';
        break;
      default:
        days = '1';
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=$days'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> prices = data['prices'];

        List<ChartData> chartData = prices.map((price) => ChartData.fromList(price)).toList();

        // Filter data based on timeframe
        DateTime now = DateTime.now();
        DateTime startTime;

        switch (timeframe) {
          case '1m':
            startTime = now.subtract(Duration(minutes: 1));
            break;
          case '20m':
            startTime = now.subtract(Duration(minutes: 20));
            break;
          case '1h':
            startTime = now.subtract(Duration(hours: 1));
            break;
          case '3h':
            startTime = now.subtract(Duration(hours: 3));
            break;
          case '24h':
            startTime = now.subtract(Duration(hours: 24));
            break;
          default:
            startTime = now.subtract(Duration(hours: 24));
        }

        return chartData.where((data) => data.time.isAfter(startTime)).toList();
      } else {
        throw Exception('Failed to load chart data');
      }
    } catch (e) {
      throw Exception('Error fetching chart data: $e');
    }
  }
}