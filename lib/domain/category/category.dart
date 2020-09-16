import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category implements _$Category {
  const Category._();

  const factory Category({String id}) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Stream<List<Category>> loadAllCategories() {
    return null;
  }
}
