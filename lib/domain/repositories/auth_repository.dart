import 'package:flutter_app/data/remote/resource.dart';
import 'package:flutter_app/data/services/work_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // 1. Get an instance of WorkService to make the API call
  final WorkService _workService = WorkService();
  static const _tokenKey = 'token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- CORRECTED LOGIN METHOD ---
  Future<bool> login(String username, String password) async {
    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      // 2. Call the service to get a real token from the server
      final resource = await _workService.getTokenByUserName(username);

      if (resource is ResourceSuccess) {
        final responseData = (resource as ResourceSuccess).data;
        final token = responseData?.result;

        if (token != null && token.isNotEmpty) {
          // 3. Save the REAL token to storage
          await saveToken(token);
          print('AuthRepository: Login successful, real token saved.');
          return true;
        } else {
          // Handle case where API returns a success response but no token data
          print('AuthRepository: Login failed, API returned no token.');
          return false;
        }
      } else if (resource is ResourceError) {
        final mess = (resource as ResourceError).message;
        print('AuthRepository: Login failed, API error - $mess');
        return false;
      }
      return false;
    } catch (e) {
      // Handle exceptions during the API call (e.g., network issues)
      print('AuthRepository: Login failed with exception: $e');
      return false;
    }
  }
}
