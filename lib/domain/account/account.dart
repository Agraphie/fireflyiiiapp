import 'package:fireflyapp/domain/transaction/transaction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account implements _$Account {
  const Account._();

  const factory Account(AccountType type, String name,
      {String iban,
      String id,
      @JsonKey(name: 'currency_symbol') String currencySymbol,
      @JsonKey(name: 'current_balance') String currentBalance}) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Stream<List<Account>> loadAllAccounts(AccountUseCase a) {
    return a.loadAllAccounts();
  }

  Stream<Transaction> transfer(
      {Account target,
      DateTime date,
      String description,
      double amount,
      String notes,
      AccountUseCase accountUseCase}) {
    return accountUseCase.transfer(
        this, target, amount, description, date, notes);
  }
}

enum AccountType {
  @JsonValue('asset')
  asset,
  @JsonValue('expense')
  expense,
  @JsonValue('import')
  import,
  @JsonValue('revenue')
  revenue,
  @JsonValue('cash')
  cash,
  @JsonValue('liability')
  liability,
  @JsonValue('liabilities')
  liabilities,
  @JsonValue('loan')
  loan,
  @JsonValue('initial-balance')
  initialBalance,
  @JsonValue('mortgage')
  mortgage,
  @JsonValue('debt')
  debt,
  @JsonValue('reconciliation')
  reconciliation
}

abstract class AccountUseCase {
  Stream<List<Account>> loadAllAccounts();

  Stream<List<Account>> loadAccountsWithType(List<AccountType> accountType);

  Stream<Account> createAccount(Account account);

  Stream<Account> updateAccount(Account account);

  Stream<Transaction> transfer(Account fromAccount, Account toAccount,
      double amount, String description, DateTime date, String notes);
}
