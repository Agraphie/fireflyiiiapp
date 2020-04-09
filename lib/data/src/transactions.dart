class TransactionsRepository {
  TransactionsRepository._privateConstructor();

  static final TransactionsRepository _instance =
      TransactionsRepository._privateConstructor();

  factory TransactionsRepository() {
    return _instance;
  }
}
