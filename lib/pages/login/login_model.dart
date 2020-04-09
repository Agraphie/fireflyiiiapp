class LoginModel {
  String secret;
  String identifier;
  Uri baseUri;
  bool baseUriValid;
  bool isValid;
  LoginModelState state;

  LoginModel(this.secret, this.identifier, this.baseUri, this.baseUriValid,
      this.isValid, this.state);
}

enum LoginModelState { loading, error, initial, success }
