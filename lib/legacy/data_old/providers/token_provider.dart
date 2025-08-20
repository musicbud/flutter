class TokenProvider {
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
  }

  void updateToken(String newToken) {
    _token = newToken;
  }
} 