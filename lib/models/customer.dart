class Customer {
  final int? id;
  final String customerName;
  final String mobileNumber;
  final String modelName;
  final String imei;
  final String purchaseDate;
  final String purchasePrice;
  final String? photoPath;
  final String? notes;
  final String deviceType;
  final String status;
  final String? soldTo;
  final String? soldMobile;
  final String? sellingPrice;
  final String? soldDate;

  Customer({
    this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.modelName,
    required this.imei,
    required this.purchaseDate,
    required this.purchasePrice,
    this.photoPath,
    this.notes,
    this.deviceType = "NEW",
    this.status = "AVAILABLE",
    this.soldTo,
    this.soldMobile,
    this.sellingPrice,
    this.soldDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'modelName': modelName,
      'imei': imei,
      'purchaseDate': purchaseDate,
      'purchasePrice': purchasePrice,
      'photoPath': photoPath,
      'notes': notes,
      'deviceType': deviceType,
      'status': status,
      'soldTo': soldTo,
      'soldMobile': soldMobile,
      'sellingPrice': sellingPrice,
      'soldDate': soldDate,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      customerName: map['customerName'],
      mobileNumber: map['mobileNumber'],
      modelName: map['modelName'],
      imei: map['imei'],
      purchaseDate: map['purchaseDate'],
      purchasePrice: map['purchasePrice'],
      photoPath: map['photoPath'],
      notes: map['notes'],
      deviceType: map['deviceType'] ?? "NEW",
      status: map['status'] ?? "AVAILABLE",
      soldTo: map['soldTo'],
      soldMobile: map['soldMobile'],
      sellingPrice: map['sellingPrice'],
      soldDate: map['soldDate'],
    );
  }
}
