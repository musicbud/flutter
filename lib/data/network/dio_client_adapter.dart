import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' show Options;
import '../network/dio_client.dart';
import '../providers/token_provider.dart';

class DioClientAdapter implements http.Client {
  final DioClient dioClient;
  final TokenProvider tokenProvider;

  DioClientAdapter({
    required this.dioClient, 
    required this.tokenProvider,
  });

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (tokenProvider.token != null) 'Authorization': 'Bearer ${tokenProvider.token}',
    };
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await dioClient.dio.get(
      url.toString(),
      options: Options(headers: headers ?? _getHeaders()),
    );
    return http.Response(response.data.toString(), response.statusCode ?? 500);
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await dioClient.dio.post(
      url.toString(),
      data: body is Map<String, dynamic> ? body : jsonDecode(jsonEncode(body)),
      options: Options(headers: headers ?? _getHeaders()),
    );
    return http.Response(response.data.toString(), response.statusCode ?? 500);
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await dioClient.put(
      url.toString(), 
      data: body is Map<String, dynamic> ? body : jsonDecode(jsonEncode(body)),
    );
    return http.Response(response.data.toString(), response.statusCode ?? 500);
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await dioClient.dio.patch(
      url.toString(), 
      data: body is Map<String, dynamic> ? body : jsonDecode(jsonEncode(body)),
    );
    return http.Response(response.data.toString(), response.statusCode ?? 500);
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await dioClient.delete(url.toString());
    return http.Response(response.data.toString(), response.statusCode ?? 500);
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    final response = await dioClient.get(url.toString());
    return http.Response('', response.statusCode ?? 500);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    return response.body;
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    return response.bodyBytes;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw UnimplementedError('send() is not implemented');
  }

  @override
  void close() {}
} 