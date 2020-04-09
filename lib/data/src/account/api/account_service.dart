import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/account/api/account_array.dart';

part 'account_service.chopper.dart';

@ChopperApi(baseUrl: '/accounts')
abstract class AccountService extends ChopperService {
  static AccountService create([ChopperClient client]) =>
      _$AccountService(client);

  @Get(path: '?type=asset')
  Future<Response<AccountArray>> getAllAccounts();
}
