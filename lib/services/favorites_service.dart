import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user's favorite products persisted locally in SharedPreferences.
class FavoritesService extends ChangeNotifier {
  static const String _storageKey = 'favorite_product_ids';

  // Singleton instance
  static final FavoritesService _instance = FavoritesService._internal();
  static FavoritesService get instance => _instance;

  FavoritesService._internal();

  factory FavoritesService() => _instance;

  final Set<String> _favoriteIds = {};
  bool _isInitialized = false;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isInitialized => _isInitialized;

  /// Initializes the service and loads stored favorites from SharedPreferences.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList(_storageKey) ?? [];
      _favoriteIds.clear();
      _favoriteIds.addAll(storedList);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _isInitialized = true;
    }
  }

  /// Checks if a product is marked as favorite.
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Toggles favorite state for a product and persists to SharedPreferences.
  Future<bool> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _persist();
      notifyListeners();
      return false;
    } else {
      _favoriteIds.add(productId);
      await _persist();
      notifyListeners();
      return true;
    }
  }

  /// Adds a product to favorites if not already present.
  Future<void> addFavorite(String productId) async {
    if (!_favoriteIds.contains(productId)) {
      _favoriteIds.add(productId);
      await _persist();
      notifyListeners();
    }
  }

  /// Removes a product from favorites.
  Future<void> removeFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _persist();
      notifyListeners();
    }
  }

  /// Clears all favorites.
  Future<void> clearAll() async {
    _favoriteIds.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, _favoriteIds.toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}
