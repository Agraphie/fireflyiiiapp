import 'dart:collection';
import 'dart:io';

import 'package:fireflyapp/domain/account/account.dart';
import 'package:rxdart/rxdart.dart';

class EditTransactionModel {
  DateTime transactionDate = DateTime.now();
  Account _fromAccount;
  Account _toAccount;

  Set<File> attachments = HashSet(hashCode: (f) {
    return f.path.hashCode;
  }, equals: (k1, k2) {
    return k1.path == k2.path;
  });
  EditTransactionModelTransaction _lastDeletedTransactionSplit;
  final Map<int, EditTransactionModelTransaction> _transactionSplits = {
    0: EditTransactionModelTransaction(id: 0)
  };

  EditTransactionModel() {
    _initListeners();
  }

  Iterable<EditTransactionModelTransaction> get transactionplits =>
      _transactionSplits.values;

  void addTransactionSplit() {
    var e = EditTransactionModelTransaction(id: _transactionSplits.length);
    _transactionSplits.putIfAbsent(e.id, () => e);
    transactionsSubject.add(_transactionSplits.values.toList());
  }

  void removeTransactionSplit(EditTransactionModelTransaction e) {
    _lastDeletedTransactionSplit = e;
    _transactionSplits.remove(e.id);
    transactionsSubject.add(_transactionSplits.values.toList());
  }

  void undoLastDeleteTransaction() {
    if (_lastDeletedTransactionSplit != null) {
      _transactionSplits.putIfAbsent(
          _lastDeletedTransactionSplit.id, () => _lastDeletedTransactionSplit);
      transactionsSubject.add(_transactionSplits.values.toList());
    }
  }

  void updateDescription(
      String description, EditTransactionModelTransaction e) {
    _transactionSplits[e.id].description = description;
  }

  void addTag(String tag, EditTransactionModelTransaction e) {
    _transactionSplits[e.id].tags.add(tag);
    transactionsSubject.add(_transactionSplits.values.toList());
  }

  void removeTag(String t, EditTransactionModelTransaction e) {
    _transactionSplits[e.id].tags.remove(t);
    transactionsSubject.add(_transactionSplits.values.toList());
  }

  void _initListeners() {
    transactionsSubject = BehaviorSubject.seeded(_transactionSplits.values.toList());
  }

  BehaviorSubject<List<EditTransactionModelTransaction>> transactionsSubject;

  void updateCategory(String c, EditTransactionModelTransaction e) {
    _transactionSplits[e.id].category = c;
    transactionsSubject.add(_transactionSplits.values.toList());
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

  void updateToAccount(Account a) {
    _toAccount = a;
  }

  void updateAmount(double amount, EditTransactionModelTransaction e) {
    _transactionSplits[e.id].amount = amount;
    transactionsSubject.add(_transactionSplits.values.toList());
  }

  void updateTransactionDate(DateTime parsedDate) {
    transactionDate = parsedDate;
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
