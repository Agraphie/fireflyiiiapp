import 'package:fireflyapp/application.dart';
import 'package:fireflyapp/pages/login/login_model.dart';
import 'package:fireflyapp/pages/login/login_view_model.dart';
import 'package:fireflyapp/widget/bezierContainer.dart';
import 'package:fireflyapp/widget/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static final String routeUri = '/login';

  static final MapEntry<String, WidgetBuilder> route = MapEntry(
    routeUri,
    (BuildContext c) => ChangeNotifierProvider<LoginViewModel>(
      create: (c) => LoginViewModel(c),
      child: LoginPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _title(context),
                  const SizedBox(
                    height: 40,
                  ),
                  _baseUrlInputField(loginViewModel),
                  const SizedBox(height: 10),
                  _secretInputField(loginViewModel),
                  const SizedBox(height: 10),
                  _identifierInputField(loginViewModel),
                  const SizedBox(
                    height: 40,
                  ),
                  _submitButton(context, loginViewModel),
                  Application.isDebugMode
                      ? Container(
                          child:
                              _loginWithMockDataButton(context, loginViewModel),
                          padding: const EdgeInsets.only(top: 20),
                        )
                      : Container()
                ],
              ),
            )),
        Positioned(
          top: -MediaQuery.of(context).size.height * .15,
          right: -MediaQuery.of(context).size.width * .4,
          child: const BezierContainer(),
        )
      ],
    );
  }

  Widget _baseUrlInputField(LoginViewModel loginViewModel) {
    return StreamBuilder<String>(
      stream: loginViewModel.baseUrlStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: loginViewModel.changeBaseUri,
          keyboardType: TextInputType.url,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
              labelText: 'Enter base URL',
              errorText: snapshot.hasError ? snapshot.error as String : null),
        );
      },
    );
  }

  Widget _identifierInputField(LoginViewModel loginViewModel) {
    return StreamBuilder<String>(
        stream: loginViewModel.identifierStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: loginViewModel.changeIdentifier,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(labelText: 'Enter identifier'),
          );
        });
  }

  Widget _secretInputField(LoginViewModel loginViewModel) {
    return StreamBuilder<String>(
        stream: loginViewModel.secretStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: loginViewModel.changeSecret,
            decoration: InputDecoration(
                labelText: 'Enter secret',
                errorText: snapshot.hasError ? snapshot.error as String : null),
            textCapitalization: TextCapitalization.none,
          );
        });
  }

  Widget _submitButton(BuildContext context, LoginViewModel loginViewModel) {
    return StreamBuilder<LoginModelState>(
        stream: loginViewModel.state,
        builder: (context, snapshot) {
          ButtonState btnState;
          switch (snapshot.data) {
            case LoginModelState.loading:
              btnState = ButtonState.inProgress;
              break;
            case LoginModelState.error:
              btnState = ButtonState.error;
              break;
            case LoginModelState.initial:
              btnState = ButtonState.normal;
              break;
            case LoginModelState.success:
              // TODO: Handle this case.
              break;
          }
          return _loginButton(loginViewModel.submit, btnState, context);
        });
  }

  Widget _loginWithMockDataButton(
      BuildContext context, LoginViewModel loginViewModel) {
    return StreamBuilder<LoginModelState>(
        stream: loginViewModel.state,
        builder: (context, snapshot) {
          ButtonState btnState;
          switch (snapshot.data) {
            case LoginModelState.loading:
              btnState = ButtonState.inProgress;
              break;
            case LoginModelState.error:
              btnState = ButtonState.error;
              break;
            case LoginModelState.initial:
              btnState = ButtonState.normal;
              break;
            case LoginModelState.success:
              // TODO: Handle this case.
              break;
          }
          return _loginButton(loginViewModel.submitMockData, btnState, context,
              title: 'Login with mock data');
        });
  }

  ProgressButton _loginButton(
      Function submitAction, ButtonState btnState, BuildContext context,
      {String title = 'Login'}) {
    return ProgressButton(
      child: Text(
        title,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: () => submitAction(),
      buttonState: btnState,
      progressColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _title(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'F',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
          children: [
            const TextSpan(
              text: 'ire',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'fly',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: 'III',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
