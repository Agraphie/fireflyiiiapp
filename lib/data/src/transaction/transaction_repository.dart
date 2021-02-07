import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_dto.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_service.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart';
import 'package:rxdart/rxdart.dart';

class TransactionRepository {
  TransactionService _transactionService;

  TransactionRepository(ChopperClient chopperClient) {
    _transactionService = chopperClient.getService<TransactionService>();
  }

  @override
  Stream<Transaction> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  Stream<Transaction> save(Transaction transaction) {
    return _transactionService
        .createTransaction(TransactionDto.fromDomainTransaction(transaction))
        .then((value) {
          return value.body;
        })
        .catchError((e) {
          print(e);
        })
        .asStream()
        .map((event) {
          return event.data;
        })
        //    .map((b) => b.attributes.copyWith(id: b.id))
        .flatMap((transactionDto) => Stream.fromIterable([]));
  }
}
