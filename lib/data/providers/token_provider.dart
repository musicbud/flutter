class TokenProvider {
  String? _token;

  String? get token => _token;

  void updateToken(String newToken) {
    _token = newToken;
  }
}