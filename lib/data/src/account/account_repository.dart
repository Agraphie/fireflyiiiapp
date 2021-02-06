import 'package:async/async.dart' show StreamGroup;
import 'package:chopper/chopper.dart';
import 'package:fireflyapp/domain/account/account.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'api/account_service.dart';

class AccountRepository implements AccountUseCase {
  AccountService _accountService;

  @override
  Stream<List<Account>> loadAllAccounts() {
    return _accountService
        .getAllAccounts()
        .then((a) => a.body)
        .then((a) => a.data)
        .asStream()
        .flatMap((a) => Stream.fromIterable(a))
        .map((b) => b.attributes.copyWith(id: b.id))
        .toList()
        .asStream();
  }

  AccountRepository(ChopperClient c) {
    _accountService = c.getService<AccountService>();
  }

  @override
  Stream<Account> createAccount(Account ac) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Stream<List<Account>> loadAccountsWithType(List<AccountType> accountType) {
    List<String> types = accountType.map(describeEnum).toList();
    return _accountService
        .getAccountsForType(types, 1)
        .then((a) {
          return a.body;
        })
        .asStream()
        //Only needed as long as API doesn't support a page size parameter.
        .flatMap((value) {
          int pages = value?.meta?.pagination?.totalPages as int ?? 1;
          if (pages > 1) {
            return StreamGroup.merge([
              Stream.value(value),
              Stream.fromIterable(Iterable<int>.generate(pages + 1))
                  // Skip the first page and "0" page, as we start the count from 0 but the Firefly API starts from 1
                  .skip(2)
                  .flatMap((i) =>
                      _accountService.getAccountsForType(types, i).asStream())
                  .map((response) => response.body)
            ]);
          } else {
            return Stream.value(value);
          }
        })
        .map((a) => a.data)
        .flatMap((a) => Stream.fromIterable(a))
        .map((b) => b.attributes.copyWith(id: b.id))
        .toList()
        .asStream();
  }

  @override
  Stream<Account> updateAccount(Account account) {
    // TODO: implement updateAccount
    throw UnimplementedError();
  }
}
