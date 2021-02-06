import 'package:fireflyapp/data/src/api/dto/meta.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_read.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_array.freezed.dart';
part 'transaction_array.g.dart';

@freezed
abstract class TransactionArray with _$TransactionArray {
  const factory TransactionArray(List<TransactionRead> data, Meta meta) =
      _TransactionArray;

  factory TransactionArray.fromJson(Map<String, dynamic> json) =>
      _$TransactionArrayFromJson(json);
}
