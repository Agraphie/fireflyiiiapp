import 'package:fireflyapp/domain/account/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction implements _$Transaction {
  const Transaction._();

  const factory Transaction(
      String id,
      TransactionType type,
      String title,
      Account fromAccount,
      Account toAccount,
      String description,
      double amount) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  static Transaction createTransaction(Account fromAccount, Account toAccount,
      double amount, String description, DateTime date, String notes) {
    TransactionType type;
    if (fromAccount.type == AccountType.asset &&
        toAccount.type == AccountType.asset) {
      type = TransactionType.transfer;
    } else if (fromAccount.type == AccountType.asset &&
        toAccount.type != AccountType.asset) {
      type = TransactionType.withdrawal;
    } else {
      type = TransactionType.deposit;
    }

    return Transaction(
        "1", type, description, fromAccount, toAccount, description, amount);
  }
}

enum TransactionType { withdrawal, deposit, transfer }
