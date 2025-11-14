class OrderDetail {
  final int clothesId;
  final int quantity;

  OrderDetail({required this.clothesId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'clothes_id': clothesId, 'quantity': quantity};
  }
}

class Order {
  final int customerId;
  final List<OrderDetail> details;

  Order({required this.customerId, required this.details});

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customerId: json['customer_id'],
      details: (json['details'] as List)
          .map(
            (detail) => OrderDetail(
              clothesId: detail['clothes_id'],
              quantity: detail['quantity'],
            ),
          )
          .toList(),
    );
  }
}
