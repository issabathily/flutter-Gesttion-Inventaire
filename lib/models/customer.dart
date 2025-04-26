class Customer {
  final String id;
  final String name;
  final String contactInfo;
  final int loyaltyPoints;
  final String lastPurchaseDate;
  final int purchaseCount;
  final double totalSpent;
  final String customerType;
  final String notes;
  final String? imageUrl;

  Customer({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.loyaltyPoints,
    required this.lastPurchaseDate,
    this.purchaseCount = 0,
    this.totalSpent = 0.0,
    this.customerType = 'Standard',
    this.notes = '',
    this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      contactInfo: json['contactInfo'],
      loyaltyPoints: int.parse(json['loyaltyPoints'].toString()),
      lastPurchaseDate: json['lastPurchaseDate'],
      purchaseCount: int.parse((json['purchaseCount'] ?? 0).toString()),
      totalSpent: double.parse((json['totalSpent'] ?? 0.0).toString()),
      customerType: json['customerType'] ?? 'Standard',
      notes: json['notes'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'loyaltyPoints': loyaltyPoints,
      'lastPurchaseDate': lastPurchaseDate,
      'purchaseCount': purchaseCount,
      'totalSpent': totalSpent,
      'customerType': customerType,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }
  
  // Helper method to check if customer is loyal (has more than 10 purchases or spent more than $1000)
  bool get isLoyal => purchaseCount >= 10 || totalSpent >= 1000.0 || loyaltyPoints >= 100;
  
  // Calculate customer tier based on spending and purchase frequency
  String get tier {
    if (totalSpent >= 5000 || purchaseCount >= 50 || loyaltyPoints >= 500) {
      return 'Platinum';
    } else if (totalSpent >= 2000 || purchaseCount >= 20 || loyaltyPoints >= 200) {
      return 'Gold';
    } else if (totalSpent >= 1000 || purchaseCount >= 10 || loyaltyPoints >= 100) {
      return 'Silver';
    } else {
      return 'Bronze';
    }
  }
  
  // Create a copy of this customer with optional new values
  Customer copyWith({
    String? id,
    String? name,
    String? contactInfo,
    int? loyaltyPoints,
    String? lastPurchaseDate,
    int? purchaseCount,
    double? totalSpent,
    String? customerType,
    String? notes,
    String? imageUrl,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      totalSpent: totalSpent ?? this.totalSpent,
      customerType: customerType ?? this.customerType,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
