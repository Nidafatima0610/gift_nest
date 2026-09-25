import 'package:flutter/foundation.dart';

import '../models/gift_box_model.dart';
import '../models/product_model.dart';

/// Manages the state, limits, customizations, and calculations for the Build My Gift flow.
class BuildGiftProvider extends ChangeNotifier {
  static const int minProducts = 2;
  static const int maxProducts = 6;
  static const double serviceFee = GiftBoxModel.defaultServiceFee; // PKR 199

  final Map<String, GiftBoxItem> _selectedItems = {};
  String _packagingStyle = 'Classic';
  String? _personalMessage;
  String? _photoPath;
  int _currentStep = 0; // 0: Choose Gifts, 1: Personalize, 2: Review

  // Packaging Styles supported by Gift Nest
  static const List<String> availablePackagingStyles = [
    'Classic',
    'Soft & Romantic',
    'Minimal',
    'Festive',
    'Cute',
  ];

  // Getters
  int get currentStep => _currentStep;
  List<GiftBoxItem> get items => _selectedItems.values.toList();
  int get selectedProductCount => _selectedItems.length;
  int get totalItemUnits =>
      _selectedItems.values.fold(0, (sum, item) => sum + item.quantity);
  bool get hasMinProducts => selectedProductCount >= minProducts;
  bool get isFull => selectedProductCount >= maxProducts;
  bool get canAddMoreProducts => selectedProductCount < maxProducts;
  String get packagingStyle => _packagingStyle;
  String? get personalMessage => _personalMessage;
  String? get photoPath => _photoPath;
  bool get hasPhoto => _photoPath != null && _photoPath!.isNotEmpty;

  double get subtotal =>
      _selectedItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + serviceFee;

  /// Checks if a product is already added to the gift box.
  bool isProductSelected(String productId) {
    return _selectedItems.containsKey(productId);
  }

  /// Returns the current quantity of a product in the gift box.
  int getProductQuantity(String productId) {
    return _selectedItems[productId]?.quantity ?? 0;
  }

  /// Adds a product to the gift box.
  /// If already present, increments its quantity.
  /// If new and limit is reached, returns false.
  bool addProduct(ProductModel product) {
    if (_selectedItems.containsKey(product.id)) {
      final current = _selectedItems[product.id]!;
      _selectedItems[product.id] = current.copyWith(quantity: current.quantity + 1);
      notifyListeners();
      return true;
    }

    if (_selectedItems.length >= maxProducts) {
      return false; // Reached 6 products limit
    }

    _selectedItems[product.id] = GiftBoxItem(product: product, quantity: 1);
    notifyListeners();
    return true;
  }

  /// Removes a product entirely from the gift box.
  void removeProduct(String productId) {
    if (_selectedItems.containsKey(productId)) {
      _selectedItems.remove(productId);
      notifyListeners();
    }
  }

  /// Updates quantity of a selected product. Removes if quantity <= 0.
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeProduct(productId);
      return;
    }

    if (_selectedItems.containsKey(productId)) {
      _selectedItems[productId] =
          _selectedItems[productId]!.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Sets packaging style.
  void setPackagingStyle(String style) {
    if (_packagingStyle != style) {
      _packagingStyle = style;
      notifyListeners();
    }
  }

  /// Sets personal message (up to 200 chars).
  void setPersonalMessage(String? message) {
    if (message != null && message.length > 200) {
      _personalMessage = message.substring(0, 200);
    } else {
      _personalMessage = (message != null && message.trim().isNotEmpty)
          ? message.trim()
          : null;
    }
    notifyListeners();
  }

  /// Sets or clears optional photo memory path.
  void setPhotoPath(String? path) {
    _photoPath = path;
    notifyListeners();
  }

  /// Sets current step index (0, 1, or 2).
  void setStep(int step) {
    if (step >= 0 && step <= 2 && _currentStep != step) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Advances to next step if validation passes.
  /// Returns false if at step 0 and fewer than 2 products selected.
  bool goToNextStep() {
    if (_currentStep == 0 && !hasMinProducts) {
      return false;
    }

    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return true;
  }

  /// Navigates to previous step if possible.
  bool goToPreviousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Resets the builder state to clean initial values.
  void clearGiftBox() {
    _selectedItems.clear();
    _packagingStyle = 'Classic';
    _personalMessage = null;
    _photoPath = null;
    _currentStep = 0;
    notifyListeners();
  }

  /// Builds and returns the final GiftBoxModel.
  GiftBoxModel buildGiftBox() {
    return GiftBoxModel(
      id: 'box_${DateTime.now().millisecondsSinceEpoch}',
      boxTitle: 'Custom Gift Box',
      packagingStyle: _packagingStyle,
      personalMessage: _personalMessage,
      photoPath: _photoPath,
      items: items,
      serviceFee: serviceFee,
      createdAt: DateTime.now(),
    );
  }
}
