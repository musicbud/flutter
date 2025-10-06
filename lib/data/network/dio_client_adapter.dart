import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' show Options, DioException;
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
    try {
      final response = await dioClient.dio.get(
        url.toString(),
        options: Options(headers: headers ?? _getHeaders()),
      );
      return http.Response(_convertDataToString(response.data), response.statusCode ?? 200);
    } on DioException catch (e) {
      return http.Response(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500
      );
    }
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      debugPrint('🔗 DioClientAdapter POST: ${url.toString()}');
      debugPrint('🔗 Body type: ${body.runtimeType}, value: $body');
      final response = await dioClient.dio.post(
        url.toString(),
        data: body,
        options: Options(headers: headers ?? _getHeaders()),
      );
      debugPrint('✅ DioClientAdapter POST success: ${response.statusCode}');
      return http.Response(_convertDataToString(response.data), response.statusCode ?? 200);
    } on DioException catch (e) {
      debugPrint('❌ DioClientAdapter POST error: ${e.message}');
      return http.Response(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500
      );
    }
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      debugPrint('🔗 DioClientAdapter PUT: ${url.toString()}');
      debugPrint('🔗 Body type: ${body.runtimeType}, value: $body');

      // Convert body to appropriate type for Dio
      dynamic convertedBody;
      if (body is Map<String, dynamic>) {
        convertedBody = body;
      } else if (body is String) {
        convertedBody = body;
      } else if (body != null) {
        convertedBody = body.toString();
      }

      final response = await dioClient.put(
        url.toString(),
        data: convertedBody,
      );
      debugPrint('✅ DioClientAdapter PUT success: ${response.statusCode}');
      return http.Response(_convertDataToString(response.data), response.statusCode ?? 200);
    } on DioException catch (e) {
      debugPrint('❌ DioClientAdapter PUT error: ${e.message}');
      return http.Response(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500
      );
    }
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      final response = await dioClient.dio.patch(
        url.toString(),
        data: body,
      );
      return http.Response(_convertDataToString(response.data), response.statusCode ?? 200);
    } on DioException catch (e) {
      return http.Response(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500
      );
    }
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      final response = await dioClient.delete(url.toString());
      return http.Response(_convertDataToString(response.data), response.statusCode ?? 200);
    } on DioException catch (e) {
      return http.Response(
        e.response?.data?.toString() ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500
      );
    }
  }

  String _convertDataToString(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is Map || data is List) return jsonEncode(data);
    return data.toString();
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