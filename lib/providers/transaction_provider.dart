import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(String name, double amount) {
    _transactions.add(
      TransactionModel(
        name: name,
        amount: amount,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}