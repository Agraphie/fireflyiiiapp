import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_dto.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_service.dart';
import 'package:fireflyapp/domain/transaction/transaction.dart';

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
        .asStream()
        .map((value) {
      return value.body;
    }).map((event) {
      return event.data;
    }).map((b) {
      return b.attributes.copyWith(id: b.id);
    }).map((event) {
      return event.toDomainTransaction();
    });
  }
}
