import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// FlutterSecureStorage를 사용한 토큰 저장/조회 유틸리티 클래스
class MyTokenStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// 저장된 액세스 토큰 조회
  /// Returns the stored access token, or null if not found
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  /// 액세스 토큰 저장
  static Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  /// 리프레시 토큰 조회
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  /// 리프레시 토큰 저장
  static Future<void> setRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  /// 토큰 정보 저장 (accessToken과 refreshToken을 함께 저장)
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refreshToken', value: refreshToken);
    }
  }

  /// 모든 토큰 삭제
  static Future<void> clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}
