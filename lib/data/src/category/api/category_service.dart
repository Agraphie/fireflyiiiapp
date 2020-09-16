import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/category/api/category_array.dart';

part 'category_service.chopper.dart';

@ChopperApi(baseUrl: '/categories')
abstract class CategoryService extends ChopperService {
  static CategoryService create([ChopperClient client]) =>
      _$CategoryService(client);

  @Get()
  Future<Response<CategoryArray>> getAllCategories();
}
