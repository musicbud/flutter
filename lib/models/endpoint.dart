/// Represents an API endpoint configuration
class Endpoint {
  final String name;
  final String method;
  final String url;
  final String status;

  const Endpoint({
    required this.name,
    required this.method,
    required this.url,
    required this.status,
  });

  /// Creates an Endpoint from JSON data
  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      name: json['name'] as String,
      method: json['method'] as String,
      url: json['url'] as String,
      status: json['status'] as String,
    );
  }

  /// Converts the Endpoint to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'method': method,
      'url': url,
      'status': status,
    };
  }

  /// Returns the URL with the {{host}} placeholder replaced
  String getUrlWithHost(String baseUrl) {
    // If URL contains http://{{host}}, replace the entire protocol + host part
    if (url.contains('http://{{host}}')) {
      return url.replaceAll('http://{{host}}', baseUrl);
    }
    // If URL contains {{host}}, replace it
    if (url.contains('{{host}}')) {
      return url.replaceAll('{{host}}', baseUrl);
    }
    // If URL is a path-only URL, return it as is (DioClient will handle base URL)
    return url;
  }

  @override
  String toString() {
    return 'Endpoint(name: $name, method: $method, url: $url, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Endpoint &&
        other.name == name &&
        other.method == method &&
        other.url == url &&
        other.status == status;
  }

  @override
  int get hashCode {
    return name.hashCode ^ method.hashCode ^ url.hashCode ^ status.hashCode;
  }
}