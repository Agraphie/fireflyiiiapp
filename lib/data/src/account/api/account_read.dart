import 'package:fireflyapp/domain/account/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_read.freezed.dart';

part 'account_read.g.dart';

@freezed
abstract class AccountRead with _$AccountRead {
  const factory AccountRead(String id, Account attributes) = _AccountRead;

  factory AccountRead.fromJson(Map<String, dynamic> json) =>
      _$AccountReadFromJson(json);
}
