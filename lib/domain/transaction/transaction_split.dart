import 'package:fireflyapp/domain/account/account.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_split.freezed.dart';
part 'transaction_split.g.dart';

@freezed
abstract class TransactionSplit implements _$TransactionSplit {
  const TransactionSplit._();

  const factory TransactionSplit(
      @nullable String id,
      TransactionType type,
      String title,
      Account fromAccount,
      Account toAccount,
      String description,
      double amount,
      DateTime date) = _TransactionSplit;

  factory TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);

  static TransactionSplit createTransactionSplit(
      Account fromAccount,
      Account toAccount,
      double amount,
      String description,
      DateTime date,
      String notes) {
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

    return TransactionSplit(null, type, description, fromAccount, toAccount,
        description, amount, date);
  }
}
