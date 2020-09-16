import 'package:fireflyapp/data/src/category/api/category_read.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_array.freezed.dart';
part 'category_array.g.dart';

@freezed
abstract class CategoryArray with _$CategoryArray {
  const factory CategoryArray(List<CategoryRead> data) = _CategoryArray;

  factory CategoryArray.fromJson(Map<String, dynamic> json) =>
      _$CategoryArrayFromJson(json);
}
