import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;
  String _filterType = 'all'; // 'all', 'loyal', 'bronze', 'silver', 'gold', 'platinum'

  List<Customer> get customers {
    switch (_filterType) {
      case 'loyal':
        return _customers.where((c) => c.isLoyal).toList();
      case 'bronze':
        return _customers.where((c) => c.tier == 'Bronze').toList();
      case 'silver':
        return _customers.where((c) => c.tier == 'Silver').toList();
      case 'gold':
        return _customers.where((c) => c.tier == 'Gold').toList();
      case 'platinum':
        return _customers.where((c) => c.tier == 'Platinum').toList();
      default:
        return _customers;
    }
  }
  
  bool get isLoading => _isLoading;
  String get filterType => _filterType;
  
  // Get list of loyal customers only
  List<Customer> get loyalCustomers => _customers.where((c) => c.isLoyal).toList();
  
  // Get customers by tier
  List<Customer> getCustomersByTier(String tier) {
    return _customers.where((c) => c.tier == tier).toList();
  }
  
  // Set filter type
  void setFilterType(String filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  // Constructor to load customers
  CustomerProvider() {
    _loadCustomers();
  }

  // Load all customers from database
  Future<void> _loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await DatabaseService.getCustomers();
    } catch (e) {
      print('Error loading customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh customers from database
  Future<void> refreshCustomers() async {
    await _loadCustomers();
  }

  // Add new customer
  Future<void> addCustomer(String name, String contactInfo, {
    String? customerType,
    String? notes,
    String? imageUrl,
  }) async {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final customer = Customer(
      id: Uuid().v4(),
      name: name,
      contactInfo: contactInfo,
      loyaltyPoints: 0,
      lastPurchaseDate: formattedDate,
      purchaseCount: 0,
      totalSpent: 0.0,
      customerType: customerType ?? 'Standard',
      notes: notes ?? '',
      imageUrl: imageUrl,
    );

    try {
      await DatabaseService.addCustomer(customer);
      _customers.add(customer);
      notifyListeners();
    } catch (e) {
      print('Error adding customer: $e');
      throw Exception('Failed to add customer');
    }
  }
  
  // Update customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      await DatabaseService.updateCustomer(customer);
      
      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating customer: $e');
      throw Exception('Failed to update customer');
    }
  }
  
  // Add loyalty points to customer
  Future<void> addLoyaltyPoints(String customerId, int points) async {
    try {
      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        final customer = _customers[index];
        final updatedCustomer = customer.copyWith(
          loyaltyPoints: customer.loyaltyPoints + points,
        );
        
        await updateCustomer(updatedCustomer);
      }
    } catch (e) {
      print('Error adding loyalty points: $e');
      throw Exception('Failed to add loyalty points');
    }
  }
  
  // Update purchase history for customer
  Future<void> recordPurchase(String customerId, double amount) async {
    try {
      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        final customer = _customers[index];
        final now = DateTime.now();
        final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        
        final updatedCustomer = customer.copyWith(
          purchaseCount: customer.purchaseCount + 1,
          totalSpent: customer.totalSpent + amount,
          lastPurchaseDate: formattedDate,
          // Add loyalty points (1 point per $10 spent)
          loyaltyPoints: customer.loyaltyPoints + (amount ~/ 10),
        );
        
        await updateCustomer(updatedCustomer);
      }
    } catch (e) {
      print('Error recording purchase: $e');
      throw Exception('Failed to record purchase');
    }
  }
  
  // Delete customer
  Future<void> deleteCustomer(String customerId) async {
    try {
      await DatabaseService.deleteCustomer(customerId);
      _customers.removeWhere((c) => c.id == customerId);
      notifyListeners();
    } catch (e) {
      print('Error deleting customer: $e');
      throw Exception('Failed to delete customer');
    }
  }
}
