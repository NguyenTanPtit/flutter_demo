// lib/data/remote/api_client.dart

import 'dart:io';import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_app/data/remote/api_helper.dart';
import 'package:flutter_app/data/remote/resource.dart';
import 'package:flutter_app/data/remote/types.dart'; // Import for BaseResponse
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
// DO NOT import WorkService here. This is the key to breaking the circular dependency.

class ApiClient {
  final Dio _dioInstance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Dio get instance => _dioInstance;

  ApiClient({String baseUrl = AppConstants.baseUrl})
      : _dioInstance = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )) {
    (_dioInstance.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('ApiClient: Bypassing certificate validation for $host:$port');
        return true;
      };
      return client;
    };

    _dioInstance.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // Prevent adding a token to the token refresh request itself.
        if (options.path.contains('getTokenByUsername')) {
          return handler.next(options);
        }

        var token = await _storage.read(key: 'token');
        if (token == null || token.isEmpty) {
          print('Token not found on storage, fetching a new one...');
          try {
            // Use the new, decoupled method.
            token = await _fetchAndSaveNewToken();
          } catch (e) {
            return handler.reject(DioException(requestOptions: options, error: e));
          }
        }
        options.headers['token'] = token;
        options.headers['username'] = 'tannv5';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e is ExpiredTokenException || (e.error is ExpiredTokenException)) {
          print('Token expired. Fetching a new one and retrying...');
          try {
            // Use the new, decoupled method here as well.
            final newToken = await _fetchAndSaveNewToken();
            final newOptions = e.requestOptions.copyWith(
              headers: {
                ...e.requestOptions.headers,
                'token': newToken,
              },
            );
            final response = await _dioInstance.fetch(newOptions);
            return handler.resolve(response);
          } catch (refreshError) {
            print('Failed to refresh token: $refreshError');
            return handler.reject(DioException(requestOptions: e.requestOptions, error: refreshError));
          }
        }
        return handler.next(e);
      },
    ));

    // LogInterceptor should be last to see the final request.
    _dioInstance.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('API Log: $obj'),
    ));
  }

  // --- NEW DECOUPLED TOKEN REFRESH METHOD ---
  Future<String> _fetchAndSaveNewToken() async {
    print('Executing _fetchAndSaveNewToken...');
    const username = 'tannv5';

    try {
      final response = await _dioInstance.get<Map<String, dynamic>>(
        'generateTokenController/getTokenByUsername',
        queryParameters: {'username': username},
      );

      // Manually parse the raw response into your BaseResponse model.
      final typedData = BaseResponse<String>.fromJson(
          response.data!, (json) => json as String
      );

      final newToken = typedData.result;

      if (newToken != null && newToken.isNotEmpty) {
        print('New token fetched successfully, saving to storage.');
        await _storage.write(key: 'token', value: newToken);
        return newToken;
      } else {
        throw Exception('API returned success but token was empty.');
      }
    } on DioException catch (e) {
      throw Exception('API Error fetching token: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error while fetching token: $e');
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dioInstance.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dioInstance.post(path, data: data, queryParameters: queryParameters);
  }
}
