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
  final dynamic storeStatusId; // 🟢 ADDED: Missing field
  final dynamic taxId; // 🟢 ADDED: Missing field
  final String createdAt; // 🟢 ADDED: Missing field
  final String updatedAt; // 🟢 ADDED: Missing field
  final String? deletedAt; // 🟢 ADDED: Missing field

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
    this.storeStatusId, // 🟢 ADDED
    this.taxId, // 🟢 ADDED
    required this.createdAt, // 🟢 ADDED
    required this.updatedAt, // 🟢 ADDED
    this.deletedAt, // 🟢 ADDED
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
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
      storeStatusId: json['store_status_id'], // 🟢 ADDED
      taxId: json['tax_id'], // 🟢 ADDED
      createdAt: json['created_at'] ?? '', // 🟢 ADDED
      updatedAt: json['updated_at'] ?? '', // 🟢 ADDED
      deletedAt: json['deleted_at'], // 🟢 ADDED
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
  final String createdAt; // 🟢 ADDED: Missing field
  final String updatedAt; // 🟢 ADDED: Missing field
  final String? deletedAt; // 🟢 ADDED: Missing field

  HistoryCustomer({
    required this.id,
    required this.name,
    required this.surname,
    required this.tel,
    required this.email,
    required this.address,
    required this.createdAt, // 🟢 ADDED
    required this.updatedAt, // 🟢 ADDED
    this.deletedAt, // 🟢 ADDED
  });

  String get fullName => '$name $surname';

  factory HistoryCustomer.fromJson(Map<String, dynamic> json) {
    return HistoryCustomer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      createdAt: json['created_at'] ?? '', // 🟢 ADDED
      updatedAt: json['updated_at'] ?? '', // 🟢 ADDED
      deletedAt: json['deleted_at'], // 🟢 ADDED
    );
  }
}

class HistoryClothes {
  final int id;
  final String name;
  final double? price;
  final String createdAt; // 🟢 ADDED: Missing field
  final String updatedAt; // 🟢 ADDED: Missing field
  final String? deletedAt; // 🟢 ADDED: Missing field

  HistoryClothes({
    required this.id,
    required this.name,
    this.price,
    required this.createdAt, // 🟢 ADDED
    required this.updatedAt, // 🟢 ADDED
    this.deletedAt, // 🟢 ADDED
  });

  factory HistoryClothes.fromJson(Map<String, dynamic> json) {
    return HistoryClothes(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      createdAt: json['created_at'] ?? '', // 🟢 ADDED
      updatedAt: json['updated_at'] ?? '', // 🟢 ADDED
      deletedAt: json['deleted_at'], // 🟢 ADDED
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
  final String createdAt; // 🟢 ADDED: Missing field
  final String updatedAt; // 🟢 ADDED: Missing field
  final String? deletedAt; // 🟢 ADDED: Missing field

  HistoryDetail({
    required this.id,
    required this.washingMachineId,
    required this.clothesId,
    required this.clothes,
    required this.quantity,
    required this.price,
    required this.total,
    required this.vat,
    required this.createdAt, // 🟢 ADDED
    required this.updatedAt, // 🟢 ADDED
    this.deletedAt, // 🟢 ADDED
  });

  factory HistoryDetail.fromJson(Map<String, dynamic> json) {
    return HistoryDetail(
      id: json['id'] ?? 0,
      washingMachineId: json['washing_machine_id'] ?? 0,
      clothesId: json['clothes_id'] ?? 0,
      clothes: HistoryClothes.fromJson(json['clothes'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      vat: double.tryParse(json['vat']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] ?? '', // 🟢 ADDED
      updatedAt: json['updated_at'] ?? '', // 🟢 ADDED
      deletedAt: json['deleted_at'], // 🟢 ADDED
    );
  }
}

class HistoryOrder {
  final int id;
  final int storeId;
  final Store store;
  final int customerId;
  final HistoryCustomer? customer; // 🟢 CHANGED: Made nullable
  final int createdBy;
  final String washingDate;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt; // 🟢 CHANGED: Made nullable and String
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
    this.customer, // 🟢 CHANGED: Made optional
    required this.createdBy,
    required this.washingDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt, // 🟢 CHANGED: Made optional
    required this.details,
    required this.subTotal,
    required this.vat,
    required this.totalVat,
    required this.total,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) {
    return HistoryOrder(
      id: json['id'] ?? 0,
      storeId: json['store_id'] ?? 0,
      store: Store.fromJson(json['store'] ?? {}),
      customerId: json['customer_id'] ?? 0,
      customer: json['customer'] != null
          ? HistoryCustomer.fromJson(json['customer'])
          : null, // 🟢 ADDED: Null check for customer
      createdBy: json['created_by'] ?? 0,
      washingDate: json['washing_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'], // 🟢 CHANGED: Can be null
      details:
          (json['details'] as List<dynamic>?)
              ?.map((detail) => HistoryDetail.fromJson(detail))
              .toList() ??
          [],
      subTotal: (json['sub_total'] as num?)?.toDouble() ?? 0.0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0.0,
      totalVat: (json['total_vat'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
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
