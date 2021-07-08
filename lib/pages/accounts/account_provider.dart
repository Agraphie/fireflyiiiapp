import 'package:fireflyapp/data/data.dart';
import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountProvider with ChangeNotifier {
  AccountRepository _accountRepository;

  AccountProvider(BuildContext context) {
    AuthProvider a = Provider.of<AuthProvider>(context, listen: false);
    _accountRepository = AccountRepository(a.authedClient);
  }

  void doasd() {
    _accountRepository.loadAllAccounts().listen(print);
    // _accountRepository.meh();
  }
}
