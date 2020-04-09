import 'package:fireflyapp/pages/accounts/account_provider.dart';
import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/login/login_page.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(primarySwatch[500].value, primarySwatch),
      ),
      home: _buildHome(context),
      routes: Map.fromEntries([
        LoginPage.route,
      ]),
    );
  }

  Widget _buildHome(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);
    if (authProvider.isLoggedIn) {
      return ChangeNotifierProvider(
        create: (c) => AccountProvider(c),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      );
    } else {
      return WelcomePage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _incrementCounter() async {
    Provider.of<AccountProvider>(context, listen: false).doasd();
//    final chopper = ChopperClient(
//      baseUrl: Uri.https("firefly.clemenskeppler.de", "/api/v1").toString(),
//      client: await getClient(),
//      converter: JsonToTypeConverter(
//          {AccountArray: (jsonData) => AccountArray.fromJson(jsonData)}),
//      services: [
//        // inject the generated service
//        AccountsService.create()
//      ],
//    );
//
//    /// retrieve your service
//    final accountService = chopper.getService<AccountsService>();
//
//    accountService.getAllAccounts().then((r) {
//      return r.body;
//    }).then((AccountArray a) {
//      print(a);
//    });
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              super.widget.title,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
