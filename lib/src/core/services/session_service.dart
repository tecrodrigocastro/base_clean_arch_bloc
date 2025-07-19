import 'package:base_clean_arch_bloc/src/core/cache/cache.dart';
import 'package:base_clean_arch_bloc/src/core/cache/shared_preferences/shared_preferences_impl.dart';

class SessionService {
  final SharedPreferencesImpl _sharedPreferencesImpl;

  SessionService({
    required SharedPreferencesImpl sharedPreferencesImpl,
  }) : _sharedPreferencesImpl = sharedPreferencesImpl;

  Future<bool> saveSession(String value) async {
    final response = await _sharedPreferencesImpl.setData(
      params: CacheParams(key: 'token', value: value),
    );

    return response;
  }

  Future<String?> getToken() async {
    final response = await _sharedPreferencesImpl.getData('token');

    if (response == null || response.isEmpty) {
      return null;
    }

    return response as String;
  }

  Future<bool> removeToken() async {
    final response = await _sharedPreferencesImpl.removeData('token');

    return response;
  }
}
