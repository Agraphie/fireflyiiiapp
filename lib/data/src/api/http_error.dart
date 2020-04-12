class HttpError extends Error {
  final int responseCode;
  final String message;
  final String uri;

  HttpError(this.responseCode, this.message, {this.uri});

  @override
  String toString() {
    return 'HttpError{responseCode: $responseCode, message: $message, uri: $uri}';
  }
}
