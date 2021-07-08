import 'dart:async';

import 'package:chopper/chopper.dart';

class HttpHeaderInterceptor implements RequestInterceptor {
  static const String _acceptHeader = 'Accept';
  static const String _contentTypeHeader = 'Content-Type';
  static const String _applicationJson = 'application/json';
  static const String _contentType = 'application/json';

  @override
  FutureOr<Request> onRequest(Request request) async {
    Request newRequest = request.copyWith(headers: {
      _acceptHeader: _applicationJson,
      _contentTypeHeader: _contentType
    });
    return newRequest;
  }
}
