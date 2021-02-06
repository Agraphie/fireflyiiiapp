import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/account/api/account_array.dart';

part 'account_service.chopper.dart';

@ChopperApi(baseUrl: '/accounts')
abstract class AccountService extends ChopperService {
  static AccountService create([ChopperClient client]) =>
      _$AccountService(client);

  @Get(path: '')
  Future<Response<AccountArray>> getAllAccounts();

  @Get()
  Future<Response<AccountArray>> getAccountsForType(
      @Query('types') List<String> accountTypes, @Query('page') int page);
}
