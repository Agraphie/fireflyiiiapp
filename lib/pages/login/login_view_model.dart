import 'dart:async';

import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:fireflyapp/pages/login/login_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validators/validators.dart' as validators;

class LoginViewModel with ChangeNotifier, WidgetsBindingObserver {
  AuthProvider _authProvider;
  final LoginModel _loginModel =
      LoginModel('', '', null, false, false, LoginModelState.initial);

  BehaviorSubject<String> _secret;
  BehaviorSubject<String> _identifier;
  BehaviorSubject<String> _baseUri;
  BehaviorSubject<bool> _isValid;
  BehaviorSubject<LoginModelState> _loginState;

  StreamTransformer<String, String> _validateUrlTransformer;

  BuildContext _context;

  Function(String) get changeSecret => _secret.sink.add;

  Function(String) get changeBaseUri => _baseUri.sink.add;

  Function(String) get changeIdentifier => _identifier.sink.add;

  void submit() {
    if (_formIsValid) {
      _loginModel.state = LoginModelState.loading;
      _loginState.add(LoginModelState.loading);
      _authProvider
          .login(
              _loginModel.baseUri, _loginModel.secret, _loginModel.identifier)
          .asStream()
          .timeout(const Duration(seconds: 30))
          .listen((event) {
        _loginState.add(LoginModelState.success);
        Navigator.pop(_context);
      }, onError: (dynamic _) {
        _loginModel.state = LoginModelState.error;
        _loginState.add(LoginModelState.error);
      });
    } else {
      _loginModel.state = LoginModelState.error;
      _loginState.add(LoginModelState.error);
    }
  }

  void submitMockData() {
    _loginModel.state = LoginModelState.loading;
    _loginState.add(LoginModelState.loading);
    _authProvider
        .loginWithMockData()
        .then((dynamic _) => _loginState.add(LoginModelState.success))
        .then((_) => Navigator.pop(_context));
  }

  Stream<String> get secretStream => _secret.stream;

  Stream<bool> get isValid => _isValid.stream;

  Stream<LoginModelState> get state => _loginState.stream;

  Stream<String> get baseUrlStream {
    return _baseUri
        .where((s) => s != null && s.isNotEmpty)
        .transform(_validateUrlTransformer);
  }

  Stream<String> get identifierStream => _identifier.stream;

  LoginViewModel(BuildContext context) {
    _context = context;
    WidgetsBinding.instance.addObserver(this);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _validateUrlTransformer = _buildUrlValidator();
    _initListeners();
  }

  void _initListeners() {
    final Duration defaultDebounceDuration = const Duration(milliseconds: 200);
    _secret = BehaviorSubject.seeded(_loginModel.secret);
    _identifier = BehaviorSubject.seeded(_loginModel.identifier);
    _baseUri = BehaviorSubject();
    _isValid = BehaviorSubject.seeded(_loginModel.isValid);
    _loginState = BehaviorSubject.seeded(_loginModel.state);
    _secret
        .where((s) => s.isNotEmpty)
        .debounceTime(defaultDebounceDuration)
        .listen((s) {
      _loginModel.secret = s.trim();
    });
    _identifier
        .where((s) => s.isNotEmpty)
        .debounceTime(defaultDebounceDuration)
        .listen((s) {
      _loginModel.identifier = s.trim();
    });
    _baseUri
        .where((s) => s.isNotEmpty)
        .debounceTime(defaultDebounceDuration)
        .map((url) => url.trim())
        .listen((s) {
      if (_loginModel.baseUriValid) {
        _loginModel.baseUri = Uri.parse(s);
      }
    });

    Rx.merge([_secret, _identifier, _baseUri])
        .where((s) => s != null && s.isNotEmpty)
        .take(1)
        .map((_) => _formIsValid)
        .listen(_isValid.add);
  }

  bool get _formIsValid =>
      _loginModel.baseUriValid &&
      _loginModel.secret.isNotEmpty &&
      _loginModel.identifier.isNotEmpty;

  StreamTransformer<String, String> _buildUrlValidator() {
    return StreamTransformer<String, String>.fromHandlers(
        handleData: (uriString, sink) {
      String trimmed = uriString.trim();
      if (validators.isURL(trimmed, requireProtocol: true, requireTld: false)) {
        _loginModel.baseUriValid = true;
        sink.add(trimmed);
      } else {
        _loginModel.baseUriValid = false;
        sink.addError('Invalid URL');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _secret.close();
    _baseUri.close();
    _isValid.close();
    _loginState.close();
    _identifier.close();
  }
}
