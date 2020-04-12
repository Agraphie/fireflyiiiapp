import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/api/http_error.dart';

class HttpErrorConverter extends ErrorConverter {
  @override
  Response convertError<ErrorType, T>(Response response) {
    final base = response.base;

    return response.copyWith<dynamic>(
        bodyError: HttpError(response.statusCode, response.body as String,
            uri: base.request.url.toString()));
  }
}
