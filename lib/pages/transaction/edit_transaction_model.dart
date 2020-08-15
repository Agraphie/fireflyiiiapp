import 'dart:collection';
import 'dart:io';

import 'package:fireflyapp/domain/account/account.dart';
import 'package:rxdart/rxdart.dart';

class EditTransactionModel {
  DateTime transactionDate;
  Account _fromAccount;
  Account _toAccount;

  Set<File> attachments = HashSet(hashCode: (f) {
    return f.path.hashCode;
  }, equals: (k1, k2) {
    return k1.path == k2.path;
  });
  EditTransactionModelTransaction _lastDeletedTransactionSplit;
  final Map<int, EditTransactionModelTransaction> _transactions = {
    0: EditTransactionModelTransaction(id: 0)
  };

  EditTransactionModel() {
    _initListeners();
  }

  Iterable<EditTransactionModelTransaction> get transactions =>
      _transactions.values;

  void addTransactionSplit() {
    var e = EditTransactionModelTransaction(id: _transactions.length);
    _transactions.putIfAbsent(e.id, () => e);
    transactionsSubject.add(_transactions.values.toList());
  }

  void removeTransactionSplit(EditTransactionModelTransaction e) {
    _lastDeletedTransactionSplit = e;
    _transactions.remove(e.id);
    transactionsSubject.add(_transactions.values.toList());
  }

  void undoLastDeleteTransaction() {
    if (_lastDeletedTransactionSplit != null) {
      _transactions.putIfAbsent(
          _lastDeletedTransactionSplit.id, () => _lastDeletedTransactionSplit);
      transactionsSubject.add(_transactions.values.toList());
    }
  }

  void updateDescription(
      String description, EditTransactionModelTransaction e) {
    _transactions[e.id].description = description;
  }

  void addTag(String tag, EditTransactionModelTransaction e) {
    _transactions[e.id].tags.add(tag);
    transactionsSubject.add(_transactions.values.toList());
  }

  void removeTag(String t, EditTransactionModelTransaction e) {
    _transactions[e.id].tags.remove(t);
    transactionsSubject.add(_transactions.values.toList());
  }

  void _initListeners() {
    transactionsSubject = BehaviorSubject.seeded(_transactions.values.toList());
  }

  BehaviorSubject<List<EditTransactionModelTransaction>> transactionsSubject;

  void updateCategory(String c, EditTransactionModelTransaction e) {
    _transactions[e.id].category = c;
    transactionsSubject.add(_transactions.values.toList());
  }

  void addFiles(List<File> l) {
    attachments.addAll(l);
  }

  void removeFile(File item) {
    attachments.remove(item);
  }

  Account get fromAccount => _fromAccount;

  Account get toAccount => _toAccount;

  void updateFromAccount(Account a) {
    _fromAccount = a;
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
