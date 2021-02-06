import 'package:fireflyapp/domain/account/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction implements _$Transaction {
  const Transaction._();

  const factory Transaction(
      TransactionType type,
      String title,
      Account fromAccount,
      Account toAccount,
      String description,
      double amount) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Stream<List<Transaction>> loadAllTransactions(TransactionUseCase a) {
    return a.loadAllTransactions();
  }

  static Stream<Transaction> spendMoney(
      Account fromAccount,
      Account toAccount,
      double amount,
      String description,
      TransactionUseCase transactionUseCase) {
    Transaction transaction = Transaction(TransactionType.withdrawal,
        'Test title', fromAccount, toAccount, description, amount);
    return transactionUseCase.spendMoney(transaction);
  }
}

enum TransactionType { withdrawal, deposit, transfer }

abstract class TransactionUseCase {
  Stream<List<Transaction>> loadAllTransactions();

  Stream<List<Transaction>> loadTransactionsWithType(
      List<TransactionType> transactionType);

  Stream<Transaction> spendMoney(Transaction transaction);

  Stream<Transaction> updateTransaction(Transaction transaction);
}
