// core/utils/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();

  // 保存 Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // 获取 Token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // 删除 Token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // 保存 Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // 获取 Refresh Token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // 删除 Refresh Token
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  // 保存用户ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  // 获取用户ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  // 删除用户ID
  static Future<void> deleteUserId() async {
    await _storage.delete(key: 'user_id');
  }

  // 清除所有存储数据
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}