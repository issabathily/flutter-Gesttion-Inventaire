class User {
  final String id;
  final String username;
  final String password;
  final String pin;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.pin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      pin: json['pin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'pin': pin,
    };
  }
}
