import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/category/api/category_service.dart';
import 'package:fireflyapp/domain/category/category.dart';
import 'package:rxdart/rxdart.dart';

class CategoryRepository {
  CategoryService _categoryService;

  Stream<List<Category>> loadAllAccounts() {
    return _categoryService
        .getAllCategories()
        .then((c) => c.body)
        .then((c) => c.data)
        .asStream()
        .flatMap((c) => Stream.fromIterable(c))
        .map((c) => c.attributes.copyWith(id: c.id))
        .toList()
        .asStream();
  }

  CategoryRepository(ChopperClient c) {
    _categoryService = c.getService<CategoryService>();
  }
}
