import 'package:retail_app/models/user.dart';
import 'package:retail_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  // Check user credentials for login
  Future<User?> login(String username, String password) async {
    final user = await DatabaseService.getUserByUsername(username);

    if (user != null && user.password == password) {
      return user;
    }

    return null;
  }

  // Register a new user
  Future<User> register(String username, String password, String pin) async {
    // Check if username already exists
    final existingUser = await DatabaseService.getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('Username already exists');
    }

    // Create new user
    final user = User(
      id: Uuid().v4(),
      username: username,
      password: password,
      pin: pin,
    );

    // Save user to database
    await DatabaseService.addUser(user);
    return user;
  }

  // Verify PIN code
  Future<bool> verifyPin(String userId, String pin) async {
    final users = await DatabaseService.getUsers();
    try {
      final user = users.firstWhere((user) => user.id == userId);
      return user.pin == pin;
    } catch (e) {
      return false;
    }
  }
}
