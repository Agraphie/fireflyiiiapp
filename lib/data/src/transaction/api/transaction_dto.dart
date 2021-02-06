import 'package:fireflyapp/domain/account/account.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart'
    as domain_transaction;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
abstract class TransactionDto implements _$TransactionDto {
  const TransactionDto._();

  const factory TransactionDto(
      TransactionDtoType type,
      String title,
      Account fromAccount,
      Account toAccount,
      String description,
      double amount) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  domain_transaction.Transaction toDomainTransaction() {
    return domain_transaction.Transaction(_toDomainTransactionType(type), title,
        fromAccount, toAccount, description, amount);
  }

  static TransactionDto fromDomainTransaction(
      domain_transaction.Transaction transaction) {
    return TransactionDto(
        _fromDomainTransactionType(transaction.type),
        transaction.title,
        transaction.fromAccount,
        transaction.toAccount,
        transaction.description,
        transaction.amount);
  }

  static TransactionDtoType _fromDomainTransactionType(
      domain_transaction.TransactionType transactionType) {
    switch (transactionType) {
      case domain_transaction.TransactionType.withdrawal:
        return TransactionDtoType.withdrawal;
      case domain_transaction.TransactionType.deposit:
        return TransactionDtoType.deposit;
      case domain_transaction.TransactionType.transfer:
        return TransactionDtoType.transfer;
      default:
        return null;
    }
  }

  domain_transaction.TransactionType _toDomainTransactionType(
      TransactionDtoType transactionType) {
    switch (transactionType) {
      case TransactionDtoType.withdrawal:
        return domain_transaction.TransactionType.withdrawal;
      case TransactionDtoType.deposit:
        return domain_transaction.TransactionType.deposit;
      case TransactionDtoType.transfer:
        return domain_transaction.TransactionType.transfer;
      default:
        return null;
    }
  }
}

enum TransactionDtoType { withdrawal, deposit, transfer }
