import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hcm_core/core/dio/hc_api.dart';
import 'package:loop_auth_module/api/model/token_response.dart';
import 'package:loop_auth_module/util/token_storage.dart';
import 'config/environment.dart';
import 'config/auth_config.dart';

class LoopAuthManager {
  static final LoopAuthManager _instance = LoopAuthManager._internal();
  factory LoopAuthManager() => _instance;
  LoopAuthManager._internal();

  String? _authHeader;
  String? _baseUrl;

  /// 초기화 - 환경 설정에 따라 헤더와 baseUrl을 고정
  /// [env]를 지정하면 해당 환경으로 설정하고 초기화합니다.
  /// [env]를 지정하지 않으면 현재 Environment 설정을 사용합니다.
  void initialize({AuthEnvironment? env}) {
    // 환경이 지정된 경우 Environment 설정
    if (env != null) {
      Environment.setEnvironment(env);
    }

    final config = Environment.authConfig;
    _baseUrl = config.baseUrl;
    _authHeader = _createBasicAuthHeader(config.clientId, config.clientSecret);
    HCApi.initialize(baseUrl: _baseUrl!);
  }

  /// Basic Authentication 헤더 생성
  String _createBasicAuthHeader(String clientId, String clientSecret) {
    final credentials = '$clientId:$clientSecret';
    final bytes = utf8.encode(credentials);
    final base64Str = base64Encode(bytes);
    return 'Basic $base64Str';
  }

  /// 외부 Client 토큰 발급 (ichms_ropc_external)
  /// userTel과 userId로 토큰 발급
  Future<TokenResponse> requestExternalClientToken({
    required String userTel, // E164 표준: 예) +821099991111
    String? userId,
    String? clientId,
    String? clientSecret,
  }) async {
    // 초기화되지 않았으면 초기화
    if (_authHeader == null || _baseUrl == null) {
      initialize();
    }

    // 파라미터로 전달된 경우에만 헤더 재생성
    String? authHeader = _authHeader;
    if (clientId != null || clientSecret != null) {
      final config = Environment.authConfig;
      final finalClientId = clientId ?? config.clientId;
      final finalClientSecret = clientSecret ?? config.clientSecret;
      authHeader = _createBasicAuthHeader(finalClientId, finalClientSecret);
    }

    final data = <String, dynamic>{
      'grant_type': 'ichms_ropc_external',
      'userTel': userTel,
    };
    if (userId != null) {
      data['userId'] = userId;
    }

    final response = await HCApi.post(
      '$_baseUrl/auth/oauth2/token',
      data: data,
      headers: {'Authorization': authHeader!},
      contentType: Headers.formUrlEncodedContentType,
    );

    final tokenResponse = TokenResponse.fromJson(response.data);
    await MyTokenStorage.saveTokens(
      accessToken: tokenResponse.accessToken,
      refreshToken: tokenResponse.refreshToken,
    );
    return tokenResponse;
  }

  /// 토큰 재발급 (ichms_refresh_token)
  /// refreshToken으로 새로운 토큰 발급
  Future<TokenResponse> refreshToken({
    String? refreshToken,
    String? clientId,
    String? clientSecret,
  }) async {
    // 초기화되지 않았으면 초기화
    if (_authHeader == null || _baseUrl == null) {
      initialize();
    }

    // 파라미터로 전달된 경우에만 헤더 재생성
    String? authHeader = _authHeader;
    if (clientId != null || clientSecret != null) {
      final config = Environment.authConfig;
      final finalClientId = clientId ?? config.clientId;
      final finalClientSecret = clientSecret ?? config.clientSecret;
      authHeader = _createBasicAuthHeader(finalClientId, finalClientSecret);
    }

    final finalRefreshToken =
        refreshToken ?? await MyTokenStorage.getRefreshToken();

    if (finalRefreshToken == null) {
      throw Exception('Refresh token is required');
    }

    final response = await HCApi.post(
      '$_baseUrl/auth/oauth2/token',
      data: {
        'grant_type': 'ichms_refresh_token',
        'refreshToken': finalRefreshToken,
      },
      headers: {'Authorization': authHeader!},
      contentType: Headers.formUrlEncodedContentType,
    );

    final tokenResponse = TokenResponse.fromJson(response.data);
    await MyTokenStorage.saveTokens(
      accessToken: tokenResponse.accessToken,
      refreshToken: tokenResponse.refreshToken,
    );
    return tokenResponse;
  }
}
