import 'package:flutter/foundation.dart';

import '../services/favorites_service.dart';

/// Provider for managing favorites within the widget tree using Provider architecture.
class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _favoritesService;

  FavoritesProvider({FavoritesService? favoritesService})
      : _favoritesService = favoritesService ?? FavoritesService.instance {
    _favoritesService.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    notifyListeners();
  }

  Set<String> get favoriteIds => _favoritesService.favoriteIds;
  bool get isInitialized => _favoritesService.isInitialized;

  Future<void> init() => _favoritesService.init();

  bool isFavorite(String productId) => _favoritesService.isFavorite(productId);

  Future<bool> toggleFavorite(String productId) =>
      _favoritesService.toggleFavorite(productId);

  Future<void> addFavorite(String productId) =>
      _favoritesService.addFavorite(productId);

  Future<void> removeFavorite(String productId) =>
      _favoritesService.removeFavorite(productId);

  Future<void> clearAll() => _favoritesService.clearAll();

  @override
  void dispose() {
    _favoritesService.removeListener(_onServiceUpdate);
    super.dispose();
  }
}
