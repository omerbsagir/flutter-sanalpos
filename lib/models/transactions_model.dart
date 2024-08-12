class TransactionModel {
  final String transactionId;
  final String date;
  final double amount;

  TransactionModel({
    required this.transactionId,
    required this.date,
    required this.amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      date: json['date'],
      amount: json['amount'],
    );
  }
}
