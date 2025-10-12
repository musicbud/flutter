class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  
  // Response structure constants
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String successKey = 'successful';
  static const String codeKey = 'code';
  
  // Common HTTP status codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
}
