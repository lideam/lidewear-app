import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

enum SortOption { priceAsc, priceDesc, nameAsc, newest }

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  String _searchQuery = '';
  String? _selectedCategory;
  SortOption? _selectedSort;
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<Product> get favoriteProducts =>
      _products.where((product) => product.isFavorite).toList();

  List<Product> get filteredAndSortedProducts {
    List<Product> filtered = [..._products];

    if (_selectedCategory != null &&
        _selectedCategory!.isNotEmpty &&
        _selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    switch (_selectedSort) {
      case SortOption.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
        break;
    }

    return filtered;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      print('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void sortProducts(SortOption? option) {
    _selectedSort = option;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index].toggleFavoriteStatus();
      notifyListeners();
    }
  }
}
