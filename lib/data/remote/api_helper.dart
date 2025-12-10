import 'package:dio/dio.dart';
import '../remote/resource.dart';

// NEW: Specific exception for an expired token.
class ExpiredTokenException implements Exception {
  final RequestOptions requestOptions;
  ExpiredTokenException(this.requestOptions);

  @override
  String toString() => 'The session token has expired.';
}

class APINoDataException implements Exception {
  final String message;
  APINoDataException(this.message);

  @override
  String toString() => message;
}

class VSmartAPIException implements Exception {
  final dynamic error;
  VSmartAPIException(this.error);

  String getUserMessage() => error.toString();
}

/// Generic T wrapper function
Future<Resource<T>> getResultWithResponse<T>(
    Future<Response<T>> Function() apiCall,
    ) async {
  try {
    final response = await apiCall();
    final contentType = response.headers.value('content-type');

    if (contentType == "LOGIN FALSE TOKEN") {
      throw ExpiredTokenException(response.requestOptions);
    }

    // ... (rest of the function is the same)
    final message = response.headers.value('message');
    if (response.statusCode == 204 && message != null && message.isNotEmpty) {
      return Resource.error(APINoDataException(message));
    }
    if (response.statusCode == 204) {
      return Resource.success(null);
    } else {
      return Resource.success(response.data);
    }

  } catch (e) {

    if (e is ExpiredTokenException) {
      rethrow;
    }
    if (e is DioException) {
      if (e.response != null) {
        if (e.response?.statusCode == 200) return Resource.success(null);
      }
    }
    if (e is VSmartAPIException) {
      return Resource.error(e.getUserMessage());
    }
    return Resource.error(e);
  }
}
