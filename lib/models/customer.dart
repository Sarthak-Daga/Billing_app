class Customer {
  final int? id;
  final String customerName;
  final String mobileNumber;
  final String modelName;
  final String imei;
  final String purchaseDate;
  final String purchasePrice;
  final String? photoPath;

  Customer({
    this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.modelName,
    required this.imei,
    required this.purchaseDate,
    required this.purchasePrice,
    this.photoPath,
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
    );
  }
}
