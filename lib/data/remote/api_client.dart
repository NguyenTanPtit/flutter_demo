// lib/data/remote/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_app/data/remote/api_helper.dart'; // Import for ExpiredTokenException
import 'package:flutter_app/data/remote/resource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../services/work_service.dart';

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
    _dioInstance.interceptors.add(QueuedInterceptorsWrapper(
      // --- onRequest handles MISSING tokens ---
      onRequest: (options, handler) async {
        if (options.path.contains('getTokenByUsername')) {
          return handler.next(options);
        }

        var token = await _storage.read(key: 'token');
        if (token == null || token.isEmpty) {
          print('Token not found on storage, fetching a new one...');
          try {
            token = await _refreshToken();
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

            final newToken = await _refreshToken();

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
        // If it's not an expired token error, just pass it along.
        return handler.next(e);
      },
    ));

    _dioInstance.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('API Log: $obj'),
    ));
  }

  // --- NEW HELPER FUNCTION to avoid code duplication ---
  Future<String> _refreshToken() async {
    print('Executing _refreshToken...');
    final username = 'tannv5';
    // NOTE: Creating a new WorkService instance here. Consider DI for a cleaner approach.
    final tokenResource = await WorkService().getTokenByUserName(username);

    if (tokenResource is ResourceSuccess) {
      final responseData = (tokenResource as ResourceSuccess).data;
      final newToken = responseData?.result;

      if (newToken != null && newToken.isNotEmpty) {
        print('New token fetched successfully, saving to storage.');
        await _storage.write(key: 'token', value: newToken);
        return newToken;
      } else {
        throw Exception('Failed to get a valid token string from the response.');
      }
    } else if (tokenResource is ResourceError) {
      throw Exception('API Error fetching token: ${(tokenResource as ResourceError).message}');
    } else {
      throw Exception('Unknown error while fetching token.');
    }
  }

  // (get and post methods remain the same)
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dioInstance.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dioInstance.post(path, data: data, queryParameters: queryParameters);
  }
}
