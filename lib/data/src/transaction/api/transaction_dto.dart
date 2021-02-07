import 'package:fireflyapp/data/src/transaction/api/transaction_split.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart'
    as domain_transaction;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
abstract class TransactionDto implements _$TransactionDto {
  const TransactionDto._();

  const factory TransactionDto(List<TransactionSplit> transactions) =
      _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  Stream<domain_transaction.Transaction> toDomainTransaction() {
    return Stream.fromIterable(transactions)
        .map((transactionSplit) => transactionSplit.toDomainTransaction());
  }

  static TransactionDto fromDomainTransaction(
      domain_transaction.Transaction transaction) {
    List<TransactionSplit> transactions = [
      TransactionSplit.fromDomainTransaction(transaction)
    ];

    return TransactionDto(transactions);
  }
}
