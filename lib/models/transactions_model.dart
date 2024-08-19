class TransactionModel {

  final String date;
  final String amount;

  TransactionModel({

    required this.date,
    required this.amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      date: json['date'],
      amount: json['amount'],
    );
  }
}
