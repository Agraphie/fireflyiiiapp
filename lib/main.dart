import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/home/home_page.dart';
import 'package:fireflyapp/pages/login/login_page.dart';
import 'package:fireflyapp/pages/transaction/edit_transaction_page.dart';
import 'package:fireflyapp/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    )
  ], child: MyApp()));
}

const Map<int, Color> primarySwatch = <int, Color>{
  50: Color(0xffe8f1f7),
  100: Color(0xffc5ddeb),
  200: Color(0xff9ec6de),
  300: Color(0xff77afd0),
  400: Color(0xff599ec6),
  500: Color(0xff3c8dbc),
  600: Color(0xff3685b6),
  700: Color(0xff2e7aad),
  800: Color(0xff2770a5),
  900: Color(0xff1a5d97),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);
    Widget home = authProvider.isLoggedIn ? HomePage.route : WelcomePage();

    Map<String, WidgetBuilder> routes = Map.fromEntries([
      LoginPage.route,
      EditTransactionPage.route,
    ]);

    return MaterialApp(
      title: 'Firefly III',
      theme: ThemeData(
        primarySwatch: MaterialColor(primarySwatch[500].value, primarySwatch),
      ),
      home: home,
      routes: routes,
    );
  }
}
