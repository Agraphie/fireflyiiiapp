import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/transaction/edit_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static final String routeUri = '/';

  static final Widget route = HomePage();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app), onPressed: authProvider.logout)
        ],
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New transaction',
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(
            context, EditTransactionPage.routeName,
            arguments: EditTransactionPageArguments('1')),
      ),
    );
  }
}
