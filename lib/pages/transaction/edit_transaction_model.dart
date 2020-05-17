import 'dart:io';

import 'package:rxdart/rxdart.dart';

class EditTransactionModel {
  DateTime transactionDate;
  String fromAccount;
  String toAccount;
  List<File> attachments;
  EditTransactionModelTransaction _lastDeletedTransactionSplit;
  Map<int, EditTransactionModelTransaction> transactions = {
    0: EditTransactionModelTransaction(id: 0)
  };

  EditTransactionModel() {
    _initListeners();
  }

  void addTransactionSplit() {
    var e = EditTransactionModelTransaction(id: transactions.length);
    transactions.putIfAbsent(e.id, () => e);
    transactionsSubject.add(transactions.values.toList());
  }

  void removeTransactionSplit(EditTransactionModelTransaction e) {
    _lastDeletedTransactionSplit = e;
    transactions.remove(e.id);
    transactionsSubject.add(transactions.values.toList());
  }

  void undoLastDeleteTransaction() {
    if (_lastDeletedTransactionSplit != null) {
      transactions.putIfAbsent(
          _lastDeletedTransactionSplit.id, () => _lastDeletedTransactionSplit);
      transactionsSubject.add(transactions.values.toList());
    }
  }

  void updateDescription(
      String description, EditTransactionModelTransaction e) {
    transactions[e.id].description = description;
  }

  void addTag(String tag, EditTransactionModelTransaction e) {
    transactions[e.id].tags.add(tag);
    transactionsSubject.add(transactions.values.toList());
  }

  void removeTag(String t, EditTransactionModelTransaction e) {
    transactions[e.id].tags.remove(t);
    transactionsSubject.add(transactions.values.toList());
  }

  void _initListeners() {
    transactionsSubject = BehaviorSubject.seeded(transactions.values.toList());
  }

  BehaviorSubject<List<EditTransactionModelTransaction>> transactionsSubject;

  void updateCategory(String c, EditTransactionModelTransaction e) {
    transactions[e.id].category = c;
    transactionsSubject.add(transactions.values.toList());
  }
}

class EditTransactionModelTransaction {
  // Simple internal id, only used for view layer
  int id;
  double amount;
  String description;
  String category;
  List<String> tags = [];

  EditTransactionModelTransaction({this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditTransactionModelTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      category.hashCode ^
      tags.hashCode;
}
