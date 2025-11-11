
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../capcoin_card.dart';
import '../services/favorite_service.dart';
import 'detailed_screen.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final favoriteCoins = favoritesService.favoriteCoins;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteCoins.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the star icon to add coins to favorites',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoriteCoins.length,
        itemBuilder: (context, index) {
          final coin = favoriteCoins[index];
          return CoinCard(
            coin: coin,
            isFavorite: true,
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
    );
  }
}