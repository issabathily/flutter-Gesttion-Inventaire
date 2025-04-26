import 'package:flutter/material.dart';
import 'package:retail_app/models/user.dart';
import 'package:retail_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isPinVerified = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPinVerified => _isPinVerified;

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      final user = await _authService.login(username, password);
      
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _isPinVerified = false; // Pin needs to be verified separately
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register new user
  Future<bool> register(String username, String password, String pin) async {
    try {
      final user = await _authService.register(username, password, pin);
      _currentUser = user;
      _isAuthenticated = true;
      _isPinVerified = false; // Pin needs to be verified separately
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Verify PIN
  Future<bool> verifyPin(String pin) async {
    if (_currentUser == null) return false;
    
    try {
      final result = await _authService.verifyPin(_currentUser!.id, pin);
      _isPinVerified = result;
      notifyListeners();
      return result;
    } catch (e) {
      print('PIN verification error: $e');
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _isPinVerified = false;
    notifyListeners();
  }
}
