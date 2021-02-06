import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/account/api/account_array.dart';
import 'package:fireflyapp/data/src/account/api/account_service.dart';
import 'package:fireflyapp/data/src/api/http_error_converter.dart';
import 'package:fireflyapp/data/src/api/http_throw_exception_interceptor.dart';
import 'package:fireflyapp/data/src/api/json_serializable_converter.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_array.dart';
import 'package:fireflyapp/data/src/transaction/api/transaction_service.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class FireflyHttpClient {
  Uri _baseUri;
  Uri _authorizationEndpoint;
  Uri _tokenEndpoint;

  final Function(String) _onChangeCallback;
  ChopperClient _chopperClient;
  oauth2.Client _authedClient;

  FireflyHttpClient(Uri baseUri, this._onChangeCallback) {
    _baseUri = baseUri;
    _tokenEndpoint = _baseUri.resolve('/oauth/token');
    _authorizationEndpoint = _baseUri.resolve('/oauth/authorize');
  }

  bool get isLoggedIn =>
      _authedClient != null && _authedClient.credentials != null;

  ChopperClient get authedClient {
    _chopperClient ??= _createChopper();
    return _chopperClient;
  }

  Future<bool> login(String savedCredentials) {
    oauth2.Credentials credentials =
        oauth2.Credentials.fromJson(savedCredentials);
    _authedClient = oauth2.Client(credentials,
        onCredentialsRefreshed: (s) => _onChangeCallback(s.toJson()));
    return Future.value(true);
  }

  Future<bool> loginFromResponse(
      Future<Map<String, String>> Function(Uri uri) _loginCallback,
      Uri redirectUri,
      String identifier,
      String secret) async {
    oauth2.AuthorizationCodeGrant grant = oauth2.AuthorizationCodeGrant(
        identifier, _authorizationEndpoint, _tokenEndpoint,
        secret: secret,
        onCredentialsRefreshed: (s) => _onChangeCallback(s.toJson()));

    Uri _uri = grant.getAuthorizationUrl(redirectUri);

    return grant
        .handleAuthorizationResponse(await _loginCallback(_uri))
        .then((oauth2.Client c) {
      _authedClient = c;
      _onChangeCallback(c.credentials.toJson());
      return true;
    });
  }

  ChopperClient _createChopper() {
    JsonSerializableConverter converter = JsonSerializableConverter({
      AccountArray: (Map<String, dynamic> jsonData) =>
          AccountArray.fromJson(jsonData),
      TransactionArray: (Map<String, dynamic> jsonData) =>
          TransactionArray.fromJson(jsonData)
    });
    return ChopperClient(
      baseUrl: Uri.https('firefly.clemenskeppler.de', '/api/v1').toString(),
      client: _authedClient,
      converter: converter,
      errorConverter: HttpErrorConverter(),
      interceptors: <ResponseInterceptor>[HttpThrowExceptionInterceptor()],
      services: [AccountService.create(), TransactionService.create()],
    );
  }

  void dispose() {
    _chopperClient?.dispose();
    _authedClient?.close();
  }
}
