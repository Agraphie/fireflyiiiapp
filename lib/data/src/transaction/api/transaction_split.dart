import 'package:fireflyapp/domain/account/account.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart'
    as domain_transaction;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_split.freezed.dart';
part 'transaction_split.g.dart';

@freezed
abstract class TransactionSplit implements _$TransactionSplit {
  const TransactionSplit._();

  const factory TransactionSplit(
      TransactionSplitType type,
      @JsonKey(name: 'description') String title,
      @JsonKey(name: 'source_id') int sourceAccountId,
      @JsonKey(name: 'destination_id') int destinationAccountId,
      String amount,
      DateTime date,
      [@JsonKey(ignore: true) Account fromAccount,
      @JsonKey(ignore: true) Account toAccount]) = _TransactionSplit;

  factory TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);

  domain_transaction.Transaction toDomainTransaction() {
    return domain_transaction.Transaction('1', _toDomainTransactionType(type),
        title, fromAccount, toAccount, null, double.parse(amount));
  }

  static TransactionSplit fromDomainTransaction(
      domain_transaction.Transaction transaction) {
    return TransactionSplit(
        _fromDomainTransactionType(transaction.type),
        transaction.title,
        int.parse(transaction.fromAccount.id),
        int.parse(transaction.toAccount.id),
        transaction.amount.toString(),
        DateTime.now(),
        transaction.fromAccount,
        transaction.toAccount);
  }

  static TransactionSplitType _fromDomainTransactionType(
      domain_transaction.TransactionType transactionType) {
    switch (transactionType) {
      case domain_transaction.TransactionType.withdrawal:
        return TransactionSplitType.withdrawal;
      case domain_transaction.TransactionType.deposit:
        return TransactionSplitType.deposit;
      case domain_transaction.TransactionType.transfer:
        return TransactionSplitType.transfer;
      default:
        return null;
    }
  }

  domain_transaction.TransactionType _toDomainTransactionType(
      TransactionSplitType transactionType) {
    switch (transactionType) {
      case TransactionSplitType.withdrawal:
        return domain_transaction.TransactionType.withdrawal;
      case TransactionSplitType.deposit:
        return domain_transaction.TransactionType.deposit;
      case TransactionSplitType.transfer:
        return domain_transaction.TransactionType.transfer;
      default:
        return null;
    }
  }
}

enum TransactionSplitType {
  @JsonValue('withdrawal')
  withdrawal,
  @JsonValue('deposit')
  deposit,
  @JsonValue('transfer')
  transfer
}
