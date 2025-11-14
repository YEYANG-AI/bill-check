class Store {
  final int id;
  final String storeNo;
  final String name;
  final String email;
  final String tel;
  final String address;
  final String logo;
  final String mapLink;
  final String bankName;
  final String bankAccountNumber;
  final String description;
  final String policy;

  Store({
    required this.id,
    required this.storeNo,
    required this.name,
    required this.email,
    required this.tel,
    required this.address,
    required this.logo,
    required this.mapLink,
    required this.bankName,
    required this.bankAccountNumber,
    required this.description,
    required this.policy,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      storeNo: json['store_no'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      tel: json['tel'] ?? '',
      address: json['address'] ?? '',
      logo: json['logo'] ?? '',
      mapLink: json['map_link'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankAccountNumber: json['bank_account_number'] ?? '',
      description: json['description'] ?? '',
      policy: json['policy'] ?? '',
    );
  }
}

class HistoryCustomer {
  final int id;
  final String name;
  final String surname;
  final String tel;
  final String email;
  final String address;

  HistoryCustomer({
    required this.id,
    required this.name,
    required this.surname,
    required this.tel,
    required this.email,
    required this.address,
  });

  String get fullName => '$name $surname';

  factory HistoryCustomer.fromJson(Map<String, dynamic> json) {
    return HistoryCustomer(
      id: json['id'],
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class HistoryClothes {
  final int id;
  final String name;
  final double? price;

  HistoryClothes({required this.id, required this.name, this.price});

  factory HistoryClothes.fromJson(Map<String, dynamic> json) {
    return HistoryClothes(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
    );
  }
}

class HistoryDetail {
  final int id;
  final int washingMachineId;
  final int clothesId;
  final HistoryClothes clothes;
  final int quantity;
  final double price;
  final double total;
  final double vat;

  HistoryDetail({
    required this.id,
    required this.washingMachineId,
    required this.clothesId,
    required this.clothes,
    required this.quantity,
    required this.price,
    required this.total,
    required this.vat,
  });

  factory HistoryDetail.fromJson(Map<String, dynamic> json) {
    return HistoryDetail(
      id: json['id'],
      washingMachineId: json['washing_machine_id'],
      clothesId: json['clothes_id'],
      clothes: HistoryClothes.fromJson(json['clothes']),
      quantity: json['quantity'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      vat: double.tryParse(json['vat'].toString()) ?? 0.0,
    );
  }
}

class HistoryOrder {
  final int id;
  final int storeId;
  final Store store;
  final int customerId;
  final HistoryCustomer customer;
  final int createdBy;
  final String washingDate;
  final String createdAt;
  final String updatedAt;
  final List<HistoryDetail> details;
  final double subTotal;
  final double vat;
  final double totalVat;
  final double total;

  HistoryOrder({
    required this.id,
    required this.storeId,
    required this.store,
    required this.customerId,
    required this.customer,
    required this.createdBy,
    required this.washingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.subTotal,
    required this.vat,
    required this.totalVat,
    required this.total,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) {
    return HistoryOrder(
      id: json['id'],
      storeId: json['store_id'],
      store: Store.fromJson(json['store']),
      customerId: json['customer_id'],
      customer: HistoryCustomer.fromJson(json['customer']),
      createdBy: json['created_by'],
      washingDate: json['washing_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      details: (json['details'] as List)
          .map((detail) => HistoryDetail.fromJson(detail))
          .toList(),
      subTotal: (json['sub_total'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      totalVat: (json['total_vat'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class HistoryResponse {
  final int statusCode;
  final String message;
  final List<HistoryOrder> data;
  final Map<String, dynamic> pagination;

  HistoryResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: (json['data'] as List)
          .map((order) => HistoryOrder.fromJson(order))
          .toList(),
      pagination: Map<String, dynamic>.from(json['pagination']),
    );
  }
}
