class Customer {
  final String id;
  final String name;
  final String contactInfo;
  final int loyaltyPoints;
  final String lastPurchaseDate;

  Customer({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.loyaltyPoints,
    required this.lastPurchaseDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      contactInfo: json['contactInfo'],
      loyaltyPoints: int.parse(json['loyaltyPoints'].toString()),
      lastPurchaseDate: json['lastPurchaseDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'loyaltyPoints': loyaltyPoints,
      'lastPurchaseDate': lastPurchaseDate,
    };
  }
}
