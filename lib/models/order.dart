class OrderItem {
  final String id;
  final String product;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["_id"],
      product: json["product"],
      quantity: json["quantity"],
      price: (json["price"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "product": product,
      "quantity": quantity,
      "price": price,
    };
  }
}

class Order {
  final String id;
  final String user;
  final List<OrderItem> items;
  final double totalAmount;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final Map<String, dynamic>? paymentResult;

  Order({
    required this.id,
    required this.user,
    required this.items,
    required this.totalAmount,
    required this.isPaid,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.paymentResult,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["_id"],
      user: json["user"],
      items: (json["items"] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json["totalAmount"] as num).toDouble(),
      isPaid: json["isPaid"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      paidAt: json["paidAt"] != null ? DateTime.parse(json["paidAt"]) : null,
      paymentResult: json["paymentResult"],
    );
  }
}
