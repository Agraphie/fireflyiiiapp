import 'package:chopper/chopper.dart';
import 'package:fireflyapp/domain/account/account.dart';
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
  Stream<List<Account>> loadAccountsWithType(AccountType accountType) {
    // TODO: implement loadAccountsWithType
    throw UnimplementedError();
  }

  @override
  Stream<Account> updateAccount(Account account) {
    // TODO: implement updateAccount
    throw UnimplementedError();
  }
}
