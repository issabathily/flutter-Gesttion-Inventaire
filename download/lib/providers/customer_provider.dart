import 'package:flutter/material.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;

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
  Future<void> addCustomer(String name, String contactInfo) async {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final customer = Customer(
      id: Uuid().v4(),
      name: name,
      contactInfo: contactInfo,
      loyaltyPoints: 0,
      lastPurchaseDate: formattedDate,
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
}
