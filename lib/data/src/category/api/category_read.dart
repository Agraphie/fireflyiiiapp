import 'package:fireflyapp/domain/category/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_read.freezed.dart';
part 'category_read.g.dart';

@freezed
abstract class CategoryRead with _$CategoryRead {
  const factory CategoryRead(String id, Category attributes) = _CategoryRead;

  factory CategoryRead.fromJson(Map<String, dynamic> json) =>
      _$CategoryReadFromJson(json);
}
