class Sale {
  final String id;
  final String date;
  final double amount;
  final double profit;
  final List<SaleItem> items;
  final String customerId;

  Sale({
    required this.id,
    required this.date,
    required this.amount,
    required this.profit,
    required this.items,
    required this.customerId,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    List<SaleItem> saleItems = [];
    if (json['items'] != null) {
      saleItems = List<SaleItem>.from(
          json['items'].map((item) => SaleItem.fromJson(item)));
    }

    return Sale(
      id: json['id'],
      date: json['date'],
      amount: double.parse(json['amount'].toString()),
      profit: double.parse(json['profit'].toString()),
      items: saleItems,
      customerId: json['customerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'profit': profit,
      'items': items.map((item) => item.toJson()).toList(),
      'customerId': customerId,
    };
  }
}

class SaleItem {
  final String productId;
  final int quantity;
  final double price;

  SaleItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      productId: json['productId'],
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
