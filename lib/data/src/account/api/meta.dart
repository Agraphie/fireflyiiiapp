import 'package:fireflyapp/data/src/account/api/pagination.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

@freezed
abstract class Meta with _$Meta {
  const factory Meta(Pagination pagination) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
