import 'package:chopper/chopper.dart';

class HttpThrowExceptionInterceptor implements ResponseInterceptor {
  @override
  Response onResponse(Response response) =>
      response.error is Exception || response.error is Error
          ? throw response.error
          : response;
}
