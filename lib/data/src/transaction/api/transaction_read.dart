import 'package:fireflyapp/data/src/transaction/api/transaction_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_read.freezed.dart';
part 'transaction_read.g.dart';

@freezed
abstract class TransactionRead with _$TransactionRead {
  const factory TransactionRead(String id, TransactionDto attributes) =
      _TransactionRead;

  factory TransactionRead.fromJson(Map<String, dynamic> json) =>
      _$TransactionReadFromJson(json);
}
