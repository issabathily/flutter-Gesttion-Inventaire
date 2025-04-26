import 'package:flutter/material.dart';
import 'package:retail_app/models/product.dart';
import 'package:retail_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _filterProducts();
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Constructor to load products
  ProductProvider() {
    _loadProducts();
  }

  // Filter products based on search query
  List<Product> _filterProducts() {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    
    final query = _searchQuery.toLowerCase();
    return _products.where((product) => 
      product.name.toLowerCase().contains(query) || 
      product.category.toLowerCase().contains(query) ||
      product.details.toLowerCase().contains(query)
    ).toList();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Load all products from database
  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await DatabaseService.getProducts();
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh products from database
  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  // Get product by ID
  Future<Product?> getProductById(String id) async {
    return await DatabaseService.getProductById(id);
  }

  // Add new product
  Future<void> addProduct(String name, String category, double price, int stock, String details) async {
    final product = Product(
      id: Uuid().v4(),
      name: name,
      category: category,
      price: price,
      stock: stock,
      imageUrl: '',
      details: details,
    );

    try {
      await DatabaseService.addProduct(product);
      _products.add(product);
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('Failed to add product');
    }
  }

  // Update product stock
  Future<void> updateProductStock(String productId, int newStock) async {
    try {
      // Find product in local list
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        // Update in memory
        _products[index] = _products[index].copyWith(stock: newStock);
        
        // Update in database
        await DatabaseService.updateProduct(_products[index]);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product stock: $e');
      throw Exception('Failed to update product');
    }
  }

  // Update entire product
  Future<void> updateProduct(Product product) async {
    try {
      // Find product in local list
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        // Update in memory
        _products[index] = product;
        
        // Update in database
        await DatabaseService.updateProduct(product);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('Failed to update product');
    }
  }
}
