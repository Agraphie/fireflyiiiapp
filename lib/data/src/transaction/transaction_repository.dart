import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_dto.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_service.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart';
import 'package:rxdart/rxdart.dart';

class TransactionRepository implements TransactionUseCase {
  TransactionService _transactionService;

  TransactionRepository(ChopperClient chopperClient) {
    _transactionService = chopperClient.getService<TransactionService>();
  }

  @override
  Stream<List<Transaction>> loadAllTransactions() {
    // TODO: implement loadAllTransactions
    throw UnimplementedError();
  }

  @override
  Stream<List<Transaction>> loadTransactionsWithType(
      List<TransactionType> transactionType) {
    // TODO: implement loadTransactionsWithType
    throw UnimplementedError();
  }

  @override
  Stream<Transaction> spendMoney(Transaction transaction) {
    return _transactionService
        .createTransaction(TransactionDto.fromDomainTransaction(transaction))
        .then((value) {
          return value.body.data;
        })
        .catchError((e) {
          print(e);
        })
        .asStream()
        .flatMap((a) => Stream.fromIterable(null));
  }

  @override
  Stream<Transaction> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }
}
