import 'package:fireflyapp/data/src/account/api/account_read.dart';
import 'package:fireflyapp/data/src/api/dto/meta.dart';
import 'package:fireflyapp/data/src/api/dto/metable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_array.freezed.dart';
part 'account_array.g.dart';

@freezed
abstract class AccountArray implements _$AccountArray, Metable {
  const factory AccountArray(List<AccountRead> data, Meta meta) = _AccountArray;

  factory AccountArray.fromJson(Map<String, dynamic> json) =>
      _$AccountArrayFromJson(json);
}
