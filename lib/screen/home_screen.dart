import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../capcoin_card.dart';
import '../model/capcoin.dart';
import '../search_bar.dart';
import '../services/capcoin_api_service.dart';
import '../services/favorite_service.dart';
import 'detailed_screen.dart';
import 'favorite_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CryptoCoin> _coins = [];
  List<CryptoCoin> _filteredCoins = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCoins() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final coins = await CryptoApiService.fetchCoins();
      setState(() {
        _coins = coins;
        _filteredCoins = coins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterCoins(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCoins = _coins;
      } else {
        _filteredCoins = _coins.where((coin) {
          return coin.name.toLowerCase().contains(query.toLowerCase()) ||
              coin.symbol.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterCoins('');
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cap Coin'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: _filterCoins,
            onClear: _clearSearch,
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text(_errorMessage),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCoins,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadCoins,
              child: _filteredCoins.isEmpty
                  ? Center(
                child: Text('No coins found'),
              )
                  : ListView.builder(
                itemCount: _filteredCoins.length,
                itemBuilder: (context, index) {
                  final coin = _filteredCoins[index];
                  return CoinCard(
                    coin: coin,
                    isFavorite: favoritesService.isFavorite(coin.id),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinDetailScreen(coin: coin),
                        ),
                      );
                    },
                    onFavoriteTap: () {
                      favoritesService.toggleFavorite(coin);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}