import 'package:fireflyapp/pages/transaction/edit_transaction_model.dart';
import 'package:flutter/material.dart';

class EditTransactionViewModel with ChangeNotifier {
  final EditTransactionModel _editTransactionModel = EditTransactionModel();

  Stream<List<EditTransactionModelTransaction>> get transactionsStream =>
      _editTransactionModel.transactionsSubject.stream;

  List<String> tags = ['Käse', 'Wurst'];
  List<String> categories = ['Food', 'Car'];

  bool get deleteTransactionsEnabled =>
      _editTransactionModel.transactions.length >= 2;

  void addNewTransaction() => _editTransactionModel.addTransactionSplit();

  void deleteTransaction(EditTransactionModelTransaction e) =>
      _editTransactionModel.removeTransactionSplit(e);

  void undoLastDeleteTransaction() =>
      _editTransactionModel.undoLastDeleteTransaction();

  void updateDescription(
          String description, EditTransactionModelTransaction e) =>
      _editTransactionModel.updateDescription(description, e);

  void addTag(String tag, EditTransactionModelTransaction e) =>
      _editTransactionModel.addTag(tag, e);

  void removeTag(String t, EditTransactionModelTransaction item) =>
      _editTransactionModel.removeTag(t, item);

  void updateCategory(String c, EditTransactionModelTransaction e) =>
      _editTransactionModel.updateCategory(c, e);

  void updateAmount(String c, EditTransactionModelTransaction e) =>
      _editTransactionModel.updateCategory(c, e);

  EditTransactionViewModel() {
    _editTransactionModel.transactionsSubject
        .listen((List<EditTransactionModelTransaction> l) {});
  }
}
