import 'package:flutter/material.dart';
import 'package:retail_app/models/sale.dart';
import 'package:retail_app/models/product.dart';
import 'package:retail_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];
  double _dailyRevenue = 0.0;
  double _totalProfit = 0.0;
  int _totalStock = 0;
  List<Map<String, dynamic>> _monthlySalesData = [];
  bool _isLoading = false;

  List<Sale> get sales => _sales;
  double get dailyRevenue => _dailyRevenue;
  double get totalProfit => _totalProfit;
  int get totalStock => _totalStock;
  List<Map<String, dynamic>> get monthlySalesData => _monthlySalesData;
  bool get isLoading => _isLoading;

  // Constructor to load sales data
  SalesProvider() {
    _loadSalesData();
  }

  // Load all sales data from database
  Future<void> _loadSalesData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load sales
      _sales = await DatabaseService.getSales();
      
      // Load dashboard metrics
      _dailyRevenue = await DatabaseService.getDailySalesAmount();
      _totalProfit = await DatabaseService.getTotalProfit();
      _totalStock = await DatabaseService.getTotalStock();
      _monthlySalesData = await DatabaseService.getMonthlySalesData();
    } catch (e) {
      print('Error loading sales data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh sales data
  Future<void> refreshSalesData() async {
    await _loadSalesData();
  }

  // Add new sale
  Future<void> addSale(List<SaleItem> items, double amount, double profit, String customerId) async {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final sale = Sale(
      id: Uuid().v4(),
      date: formattedDate,
      amount: amount,
      profit: profit,
      items: items,
      customerId: customerId,
    );

    try {
      await DatabaseService.addSale(sale);
      _sales.add(sale);
      
      // Update metrics
      _dailyRevenue += amount;
      _totalProfit += profit;
      
      notifyListeners();
    } catch (e) {
      print('Error adding sale: $e');
      throw Exception('Failed to add sale');
    }
  }

  // Process a sale by updating product stock
  Future<void> processSale(List<Product> products, List<int> quantities, String customerId) async {
    try {
      double totalAmount = 0.0;
      double totalProfit = 0.0;
      List<SaleItem> saleItems = [];

      // Calculate totals and create sale items
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        final quantity = quantities[i];
        
        // Calculate item total
        final itemTotal = product.price * quantity;
        
        // Estimate profit (30% of sale price for this example)
        final itemProfit = itemTotal * 0.3;
        
        totalAmount += itemTotal;
        totalProfit += itemProfit;
        
        // Create sale item
        saleItems.add(SaleItem(
          productId: product.id,
          quantity: quantity,
          price: product.price,
        ));
      }

      // Add the sale
      await addSale(saleItems, totalAmount, totalProfit, customerId);
      
      // Update stock for each product
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        final newStock = product.stock - quantities[i];
        
        // Update product stock
        await DatabaseService.updateProduct(
          product.copyWith(stock: newStock)
        );
      }
      
      // Refresh data
      await refreshSalesData();
    } catch (e) {
      print('Error processing sale: $e');
      throw Exception('Failed to process sale');
    }
  }
}
