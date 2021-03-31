import 'package:chopper/chopper.dart';
import 'package:fireflyapp/application.dart';
import 'package:fireflyapp/data/data.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri redirectUrl = Uri.parse('http://empty');
const String _credentialsKey = 'de.clemenskeppler.fireflyapp.OAUTH_CREDENTIALS';
const String _baseUriKey = 'de.clemenskeppler.fireflyapp.LATEST_BASE_URI';
const _fingerPrintEnabledSPKey =
    'de.clemenskeppler.fireflyapp.FINGERPRINT_ENABLED';

class AuthProvider with ChangeNotifier {
  FireflyHttpClient _fireflyHttpClient;
  Future<Uri> _baseUri;
  bool _isLoggedIn = false;

  ChopperClient get authedClient => _fireflyHttpClient.authedClient;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    Future<Uri> loadFromSp = _loadFromSharedPreferences()
      ..then((_) {
        SharedPreferences.getInstance().then((sp) {
          String savedCredentials = sp.get(_credentialsKey) as String;
          if (savedCredentials != null) {
            _fireflyHttpClient
                .login(savedCredentials)
                .then(successfullyLoggedIn);
          }
        });
      });
    _baseUri = Future.value(loadFromSp);
  }

  Future<Uri> _loadFromSharedPreferences() {
    return SharedPreferences.getInstance().then((sp) {
      String baseUri = sp.get(_baseUriKey) as String;
      if (baseUri != null && baseUri.isNotEmpty) {
        Uri uri = Uri.parse(baseUri);
        _fireflyHttpClient = _buildClient(uri);
        return uri;
      }
      return null;
    });
  }

  /// Return auth credentials
  Future<Map<String, String>> _launchOauth2Login(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      // ignore: only_throw_errors
      throw 'Could not launch $uri.toString()';
    }

    return getUriLinksStream().first.then((Uri uri) => uri.queryParameters);
  }

  Future<bool> login(Uri baseUri, String secret, String identifier) {
    if (_isLoggedIn) {
      return Future.value(true);
    }

    _fireflyHttpClient = _buildClient(baseUri);
    return _fireflyHttpClient
        .loginFromResponse(_launchOauth2Login, redirectUrl, identifier, secret)
        .then((c) {
      _saveBaseUri(baseUri);
      return c;
    }).then(successfullyLoggedIn);
  }

  Future<bool> loginWithMockData() {
    if (_isLoggedIn) {
      return Future.value(true);
    }

    return Future<dynamic>.delayed(const Duration(seconds: 1))
        .then((dynamic _) => true)
        .then((_) => Application.mockDataEnabled = true)
        .then(successfullyLoggedIn);
  }

  FireflyHttpClient _buildClient(Uri uri) {
    return FireflyHttpClient(uri, _saveCredentials);
  }

  bool successfullyLoggedIn(bool loggedIn) {
    _isLoggedIn = true;
    notifyListeners();
    return _isLoggedIn;
  }

  void _saveCredentials(String credentials) {
    SharedPreferences.getInstance().then(
        (SharedPreferences sp) => sp.setString(_credentialsKey, credentials));
  }

  void _saveBaseUri(Uri uri) {
    SharedPreferences.getInstance().then(
        (SharedPreferences sp) => sp.setString(_baseUriKey, uri.toString()));
    _baseUri = Future.value(uri);
  }

  Future<Uri> getBaseUri() {
    return _baseUri;
  }

  void logout() {
    SharedPreferences.getInstance().then((sp) {
      sp..remove(_baseUriKey)..remove(_credentialsKey);
    });
    // Possibly in mock state, so not available
    _fireflyHttpClient?.dispose();
    _fireflyHttpClient = null;
    _baseUri = null;
    _isLoggedIn = false;
    deactivateFingerprint();
    Application.reset();
    notifyListeners();
  }

  Future<bool> fingerprintLoginActivated() {
    return SharedPreferences.getInstance()
        .then((sp) => sp.getBool(_fingerPrintEnabledSPKey) ?? false);
  }

  void deactivateFingerprint() {
    SharedPreferences.getInstance().then(
      (sp) {
        sp.remove(_fingerPrintEnabledSPKey);
      },
    );
  }

  Future<bool> activateFingerprint() {
    var la = LocalAuthentication();
    return la
        .authenticate(
            localizedReason: 'Verify that it is you', biometricOnly: true)
        .then((success) {
      if (success) {
        SharedPreferences.getInstance().then(
          (sp) {
            sp.setBool(_fingerPrintEnabledSPKey, true);
          },
        );
      }
      return success;
    });
  }

  Future<bool> attemptFingerprintLogin() {
    var la = LocalAuthentication();
    return la
        .authenticate(
            localizedReason: 'Verify that it is you', biometricOnly: true)
        .then((success) {
      if (success) {
        successfullyLoggedIn(success);
      }
      return success;
    });
  }
}
