import 'dart:convert';
import 'dart:html' as html;
import 'package:retail_app/models/user.dart';
import 'package:retail_app/models/product.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/models/sale.dart';

class DatabaseService {
  static Map<String, dynamic> _data = {
    'users': [],
    'products': [],
    'customers': [],
    'sales': [],
  };
  static bool _initialized = false;

  // Initialize the database in local storage
  static Future<void> init() async {
    if (_initialized) return;

    try {
      // Check if data exists in local storage
      final storedData = html.window.localStorage['retail_app_data'];
      
      if (storedData != null && storedData.isNotEmpty) {
        // Read existing data from local storage
        _data = jsonDecode(storedData);
      } else {
        // Initialize with empty data and save to local storage
        html.window.localStorage['retail_app_data'] = jsonEncode(_data);
      }

      _initialized = true;
    } catch (e) {
      print('Database initialization error: $e');
      throw Exception('Failed to initialize database');
    }
  }

  // Save data to local storage
  static Future<void> _saveData() async {
    try {
      html.window.localStorage['retail_app_data'] = jsonEncode(_data);
    } catch (e) {
      print('Error saving data: $e');
      throw Exception('Failed to save data');
    }
  }

  // USERS
  static Future<List<User>> getUsers() async {
    await init();
    List<dynamic> userList = _data['users'];
    return userList.map((json) => User.fromJson(json)).toList();
  }

  static Future<User?> getUserByUsername(String username) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  static Future<void> addUser(User user) async {
    await init();
    _data['users'].add(user.toJson());
    await _saveData();
  }

  // PRODUCTS
  static Future<List<Product>> getProducts() async {
    await init();
    List<dynamic> productList = _data['products'];
    return productList.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product?> getProductById(String id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> addProduct(Product product) async {
    await init();
    _data['products'].add(product.toJson());
    await _saveData();
  }

  static Future<void> updateProduct(Product product) async {
    await init();
    final index = _data['products'].indexWhere((p) => p['id'] == product.id);
    if (index != -1) {
      _data['products'][index] = product.toJson();
      await _saveData();
    }
  }

  // CUSTOMERS
  static Future<List<Customer>> getCustomers() async {
    await init();
    List<dynamic> customerList = _data['customers'];
    return customerList.map((json) => Customer.fromJson(json)).toList();
  }

  static Future<void> addCustomer(Customer customer) async {
    await init();
    _data['customers'].add(customer.toJson());
    await _saveData();
  }

  // SALES
  static Future<List<Sale>> getSales() async {
    await init();
    List<dynamic> salesList = _data['sales'];
    return salesList.map((json) => Sale.fromJson(json)).toList();
  }

  static Future<void> addSale(Sale sale) async {
    await init();
    _data['sales'].add(sale.toJson());
    await _saveData();
  }

  // Get sales for a specific date range
  static Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final sales = await getSales();
    return sales.where((sale) {
      final saleDate = DateTime.parse(sale.date);
      return saleDate.isAfter(start.subtract(Duration(days: 1))) && 
             saleDate.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }

  // Get daily sales amount for the current day
  static Future<double> getDailySalesAmount() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final sales = await getSalesByDateRange(today, today);
    return sales.fold<double>(0.0, (sum, sale) => sum + sale.amount);
  }

  // Get total profit
  static Future<double> getTotalProfit() async {
    final sales = await getSales();
    return sales.fold<double>(0.0, (sum, sale) => sum + sale.profit);
  }

  // Get total stock count
  static Future<int> getTotalStock() async {
    final products = await getProducts();
    return products.fold<int>(0, (sum, product) => sum + product.stock);
  }

  // Get monthly sales data for chart
  static Future<List<Map<String, dynamic>>> getMonthlySalesData() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    List<Map<String, dynamic>> monthlyData = [];
    
    // Create a map for each day of the month
    for (int i = 1; i <= endOfMonth.day; i++) {
      monthlyData.add({
        'day': i,
        'amount': 0.0,
      });
    }
    
    // Get sales for this month
    final monthlySales = await getSalesByDateRange(startOfMonth, endOfMonth);
    
    // Populate the data
    for (var sale in monthlySales) {
      final saleDate = DateTime.parse(sale.date);
      final dayIndex = saleDate.day - 1; // Adjust for zero-based index
      monthlyData[dayIndex]['amount'] += sale.amount;
    }
    
    return monthlyData;
  }
}
