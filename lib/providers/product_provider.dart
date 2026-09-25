import 'package:flutter/foundation.dart';

import '../models/category_model.dart';
import '../models/creator_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

/// Manages products, categories, creators, and gift filtering state.
class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  ProductProvider({ProductService? productService})
      : _productService = productService ?? ProductServiceImpl();

  List<ProductModel> _products = const [];
  List<ProductModel> _popularProducts = const [];
  List<CategoryModel> _categories = const [];
  List<CreatorModel> _creators = const [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter States for Gift Finder & Explore
  String? _selectedCategory;
  String? _selectedRecipient;
  String? _selectedOccasion;
  double? _maxBudget;

  List<ProductModel> get products => _products;
  List<ProductModel> get popularProducts => _popularProducts;
  List<CategoryModel> get categories => _categories;
  List<CreatorModel> get creators => _creators;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get selectedCategory => _selectedCategory;
  String? get selectedRecipient => _selectedRecipient;
  String? get selectedOccasion => _selectedOccasion;
  double? get maxBudget => _maxBudget;

  void setCategoryFilter(String? categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setRecipientFilter(String? recipient) {
    _selectedRecipient = recipient;
    notifyListeners();
  }

  void setOccasionFilter(String? occasion) {
    _selectedOccasion = occasion;
    notifyListeners();
  }

  void setBudgetFilter(double? maxBudget) {
    _maxBudget = maxBudget;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = null;
    _selectedRecipient = null;
    _selectedOccasion = null;
    _maxBudget = null;
    notifyListeners();
  }

  Future<void> fetchCatalog() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _categories = await _productService.getCategories();
      _popularProducts = await _productService.getPopularProducts();
      _creators = await _productService.getFeaturedCreators();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
