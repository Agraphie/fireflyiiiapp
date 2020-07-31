import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xff3c8dbc), const Color(0xff3c8dbc)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              const SizedBox(
                height: 80,
              ),
              _loginButton(context),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<bool>(
                future: authProvider.fingerprintLoginActivated(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data) {
                    return Container();
                  }
                  _attemptFingerprintLogin(authProvider);
                  return _buildTouchIdLoginHint(authProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, LoginPage.routeUri);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xff3c8dbc).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xff3c8dbc)),
        ),
      ),
    );
  }

  Widget _buildTouchIdLoginHint(AuthProvider authProvider) {
    return GestureDetector(
      onTap: () => _attemptFingerprintLogin(authProvider),
      child: Container(
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          child: Column(
            children: <Widget>[
              const Text(
                'Quick login with Touch ID',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              Icon(Icons.fingerprint, size: 90, color: Colors.white),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Touch ID',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          )),
    );
  }

  void _attemptFingerprintLogin(AuthProvider authProvider) {
    authProvider.attemptFingerprintLogin();
  }

  Widget _title() {
    return Text('Firefly III',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ));
  }
}
