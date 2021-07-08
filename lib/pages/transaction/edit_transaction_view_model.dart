import 'dart:io';

import 'package:fireflyapp/data/src/account/account_repository.dart';
import 'package:fireflyapp/domain/account/account.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart';
import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/transaction/edit_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class EditTransactionViewModel with ChangeNotifier {
  final EditTransactionModel _editTransactionModel = EditTransactionModel();

  AccountRepository _accountRepository;

  BuildContext _context;

  Stream<List<EditTransactionModelTransaction>> get splitTransactionsStream =>
      _editTransactionModel.transactionsSubject.stream;

  BehaviorSubject<EditTransactionModel> _editTransactionModelSubject;
  final BehaviorSubject<bool> _showTitle = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _inProgress = BehaviorSubject.seeded(false);
  final BehaviorSubject<String> _errors = BehaviorSubject();

  Stream<bool> get showTitle => _showTitle.stream;
  Stream<bool> get inProgress => _inProgress.stream;
  Stream<String> get errors => _errors.stream;

  Stream<EditTransactionModel> get transactionStream =>
      _editTransactionModelSubject.stream;

  List<String> tags = ['Käse', 'Wurst'];
  List<String> categories = ['Food', 'Car'];
  List<Account> allAccounts = [];
  Iterable<File> get attachments => _editTransactionModel.attachments;
  DateTime get transactionDate => _editTransactionModel.transactionDate;

  final Set<AccountType> _validFromAccountTypes = {
    AccountType.asset,
    AccountType.revenue,
    AccountType.loan,
    AccountType.debt,
    AccountType.mortgage
  };

  final Set<AccountType> _validToAccountTypes = {
    AccountType.asset,
    AccountType.expense,
    AccountType.loan,
    AccountType.debt,
    AccountType.mortgage
  };

  EditTransactionViewModel(BuildContext context) {
    _context = context;
    AuthProvider a = Provider.of<AuthProvider>(context, listen: false);
    _accountRepository = AccountRepository(a.authedClient);
    _accountRepository.loadAccountsWithType([
      AccountType.asset,
      AccountType.revenue,
      AccountType.loan,
      AccountType.debt,
      AccountType.mortgage
    ]).listen((accounts) {
      return allAccounts = accounts;
    });
    _editTransactionModelSubject =
        BehaviorSubject.seeded(_editTransactionModel);
    _editTransactionModel.transactionsSubject
        .listen((List<EditTransactionModelTransaction> l) {});
  }

  bool get deleteTransactionsEnabled =>
      _editTransactionModel.transactionSplits.length >= 2;

  void addNewTransaction() {
    _editTransactionModel.addTransactionSplit();
    _showTitle.add(_editTransactionModel.transactionSplits.length >= 2);
  }

  void deleteTransaction(EditTransactionModelTransaction e) {
    _editTransactionModel.removeTransactionSplit(e);
    _showTitle.add(_editTransactionModel.transactionSplits.length >= 2);
  }

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

  void updateAmount(String amount, EditTransactionModelTransaction e) {
    var parsedAmount = double.parse(amount);
    _editTransactionModel.updateAmount(parsedAmount, e);
  }

  void updateFromAccount(Account a) {
    _editTransactionModel.updateFromAccount(a);
    _editTransactionModelSubject.add(_editTransactionModel);
  }

  void updateToAccount(Account a) {
    _editTransactionModel.updateToAccount(a);
    _editTransactionModelSubject.add(_editTransactionModel);
  }

  void updateTransactionDate(String date) {
    var parsedDate = DateTime.parse(date);
    _editTransactionModel.updateTransactionDate(parsedDate);
  }

  void updateTitle(String title) {
    _editTransactionModel.transactionTitle = title;
  }

  Iterable<Account> fromAccounts() {
    return allAccounts.where((a) => _validFromAccountTypes.contains(a.type));
  }

  Iterable<Account> toAccounts() {
    return allAccounts.where((a) => _validToAccountTypes.contains(a.type));
  }

  void addFiles(List<File> l) {
    _editTransactionModel.addFiles(l);
    _editTransactionModelSubject.add(_editTransactionModel);
  }

  void removeFile(File item) {
    _editTransactionModel.removeFile(item);
    _editTransactionModelSubject.add(_editTransactionModel);
  }

  void saveTransactions() {
    _inProgress.add(true);
    if (_editTransactionModel.transactionSplits.length == 1) {
      updateTitle(null);
    }

    final Transaction newTransaction = Transaction.createTransaction(
        groupTitle: _editTransactionModel.transactionTitle);

    Stream.fromIterable(_editTransactionModel.transactionSplits)
        .map((e) => newTransaction.addSplit(
            _editTransactionModel.fromAccount,
            _editTransactionModel.toAccount,
            e.amount,
            e.description,
            _editTransactionModel.transactionDate,
            ''))
        .flatMap((value) {
      return _editTransactionModel.fromAccount.transfer(
          transaction: newTransaction, accountUseCase: _accountRepository);
    }).listen((event) {
      _inProgress.add(false);
      dispose();
      Navigator.of(_context).pop();
    }, onError: (Object e) {
      _inProgress.add(false);
      _errors.add(e.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editTransactionModelSubject.close();
    _inProgress.close();
    _showTitle.close();
    _errors.close();
  }
}
