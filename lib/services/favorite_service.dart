import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/capcoin.dart';
import 'package:flutter/foundation.dart';


class FavoritesService extends ChangeNotifier {
  List<String> _favoriteIds = [];
  Map<String, CryptoCoin> _favoriteCoins = {};

  List<String> get favoriteIds => _favoriteIds;
  List<CryptoCoin> get favoriteCoins => _favoriteCoins.values.toList();

  FavoritesService() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorite_coins');

    if (favoritesJson != null) {
      try {
        Map<String, dynamic> decoded = json.decode(favoritesJson);
        _favoriteIds = List<String>.from(decoded['ids'] ?? []);

        Map<String, dynamic> coinsMap = decoded['coins'] ?? {};
        _favoriteCoins = coinsMap.map(
              (key, value) => MapEntry(key, CryptoCoin.fromJson(value)),
        );
        notifyListeners();
      } catch (e) {
        print('Error loading favorites: $e');
      }
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> coinsMap = _favoriteCoins.map(
          (key, value) => MapEntry(key, value.toJson()),
    );

    String favoritesJson = json.encode({
      'ids': _favoriteIds,
      'coins': coinsMap,
    });

    await prefs.setString('favorite_coins', favoritesJson);
  }

  bool isFavorite(String coinId) {
    return _favoriteIds.contains(coinId);
  }

  Future<void> toggleFavorite(CryptoCoin coin) async {
    if (_favoriteIds.contains(coin.id)) {
      _favoriteIds.remove(coin.id);
      _favoriteCoins.remove(coin.id);
    } else {
      _favoriteIds.add(coin.id);
      _favoriteCoins[coin.id] = coin;
    }

    await _saveFavorites();
    notifyListeners();
  }

  Future<void> updateFavoriteCoin(CryptoCoin coin) async {
    if (_favoriteIds.contains(coin.id)) {
      _favoriteCoins[coin.id] = coin;
      await _saveFavorites();
      notifyListeners();
    }
  }
}