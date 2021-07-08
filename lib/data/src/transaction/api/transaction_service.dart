import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_array.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_dto.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_single.dart';

part 'transaction_service.chopper.dart';

@ChopperApi(baseUrl: '/transactions')
abstract class TransactionService extends ChopperService {
  static TransactionService create([ChopperClient client]) =>
      _$TransactionService(client);

  @Get(path: '')
  Future<Response<TransactionArray>> getAllTransactions();

  @Get()
  Future<Response<TransactionArray>> getTransactionsForType(
      @Query('types') List<String> transactionTypes, @Query('page') int page);

  @Post()
  Future<Response<TransactionSingle>> createTransaction(
      @Body() TransactionDto transaction);
}
