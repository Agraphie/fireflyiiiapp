import 'package:chopper/chopper.dart';

class HttpThrowExceptionInterceptor implements ResponseInterceptor {
  @override
  Response onResponse(Response response) =>
      response.error is Exception || response.error is Error
          // ignore: only_throw_errors
          ? throw response.error
          : response;
}
