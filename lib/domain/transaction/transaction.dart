import 'package:fireflyapp/domain/account/account.dart';
import 'package:fireflyapp/domain/transaction/transaction_split.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction implements _$Transaction {
  const Transaction._();

  const factory Transaction(
          @nullable String id, List<TransactionSplit> transactionSplits) =
      _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  static Transaction createTransaction({String id}) {
    return Transaction(id ?? null, []);
  }

  Transaction addSplit(Account fromAccount, Account toAccount, double amount,
      String description, DateTime date, String notes) {
    TransactionSplit split = TransactionSplit.createTransactionSplit(
        fromAccount, toAccount, amount, description, date, notes);
    transactionSplits.add(split);

    return this;
  }

  bool valid() {
    return transactionSplits?.isNotEmpty;
  }
}

enum TransactionType { withdrawal, deposit, transfer }
