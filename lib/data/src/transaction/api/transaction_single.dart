import 'package:fireflyapp/data/src/transaction/api/transaction_read.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_single.freezed.dart';
part 'transaction_single.g.dart';

@freezed
abstract class TransactionSingle with _$TransactionSingle {
  const factory TransactionSingle(TransactionRead data) = _TransactionSingle;

  factory TransactionSingle.fromJson(Map<String, dynamic> json) =>
      _$TransactionSingleFromJson(json);
}
