class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/v1';
  static const int connectTimeout = 5000; // milliseconds
  static const int receiveTimeout = 3000; // milliseconds
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
