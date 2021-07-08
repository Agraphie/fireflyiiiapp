import 'package:fireflyapp/data/src/transaction/api/transaction_split.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart'
    as domain_transaction;
import 'package:fireflyapp/domain/transaction/transaction_split.dart'
    as domain_transaction_split;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
abstract class TransactionDto implements _$TransactionDto {
  const TransactionDto._();

  const factory TransactionDto(
      @nullable String id,
      @JsonKey(name: 'group_title') @nullable String groupTitle,
      List<TransactionSplit> transactions) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  domain_transaction.Transaction toDomainTransaction() {
    List<domain_transaction_split.TransactionSplit> transactionSplits =
        transactions.map((e) => e.toDomainTransactionSplit()).toList();

    return domain_transaction.Transaction(id, groupTitle, transactionSplits);
  }

  static TransactionDto fromDomainTransaction(
      domain_transaction.Transaction transaction) {
    List<TransactionSplit> transactions = transaction.transactionSplits
        .map(TransactionSplit.fromDomainTransactionSplit)
        .toList();

    return TransactionDto(transaction.id, transaction.groupTitle, transactions);
  }
}
