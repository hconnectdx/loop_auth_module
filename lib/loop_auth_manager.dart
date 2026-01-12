import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hcm_core/core/dio/hc_api.dart';
import 'package:loop_auth_module/api/model/token_response.dart';
import 'package:loop_auth_module/util/token_storage.dart';
import 'config/environment.dart';

class LoopAuthManager {
  static final LoopAuthManager _instance = LoopAuthManager._internal();
  factory LoopAuthManager() => _instance;
  LoopAuthManager._internal();

  String? _authHeader;
  String? _baseUrl;

  /// 초기화 - 환경 설정에 따라 헤더와 baseUrl을 고정
  void initialize() {
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
    await TokenStorage.saveTokens(
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
        refreshToken ?? await TokenStorage.getRefreshToken();

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
    await TokenStorage.saveTokens(
      accessToken: tokenResponse.accessToken,
      refreshToken: tokenResponse.refreshToken,
    );
    return tokenResponse;
  }

  /// 건강데이터 전송 (샘플 데이터)
  /// API 스펙: POST /discovery/api/lifelogs/v1/users
  Future<Map<String, dynamic>?> sendHealthSampleData() async {
    // 초기화되지 않았으면 초기화
    if (_authHeader == null || _baseUrl == null) {
      initialize();
    }

    // sampleData를 복사하고 lifeLogRawDatas만 JSON 문자열로 변환
    final requestBody = Map<String, dynamic>.from(sampleData);

    try {
      final accessToken = await TokenStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token is required. Please authenticate first.');
      }

      final response = await HCApi.post(
        '$_baseUrl/discovery/api/lifelogs/v1/users',
        data: requestBody,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Health data sent successfully');
        // response.data가 null이거나 빈 값인 경우
        if (response.data == null) {
          return null;
        }
        // response.data가 String인 경우 Map으로 변환
        if (response.data is String) {
          final dataString = response.data as String;
          if (dataString.isEmpty) {
            return null;
          }
          return jsonDecode(dataString) as Map<String, dynamic>?;
        }
        return response.data as Map<String, dynamic>?;
      } else if (response.statusCode == 400) {
        print('Error sending health data: ${response.data}');
        // response.data가 null이거나 빈 값인 경우
        if (response.data == null) {
          return null;
        }
        // response.data가 String인 경우 Map으로 변환
        if (response.data is String) {
          final dataString = response.data as String;
          if (dataString.isEmpty) {
            return null;
          }
          return jsonDecode(dataString) as Map<String, dynamic>?;
        }
        return response.data as Map<String, dynamic>?;
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending health data: $e');
      rethrow;
    }
  }

  /// 건강데이터 전송 (커스텀 데이터)
  /// API 스펙: POST /discovery/api/lifelogs/v1/users
  Future<Map<String, dynamic>?> sendHealthData({
    required String userId,
    required Map<String, dynamic> lifeLogRawDatas,
    required String platformType, // 20301101: Android, 20301102: IOS
    required String deviceType,
    String? measLocation,
  }) async {
    // 초기화되지 않았으면 초기화
    if (_authHeader == null || _baseUrl == null) {
      initialize();
    }

    // lifeLogRawDatas를 JSON 문자열로 변환
    final lifeLogRawDatasJson = jsonEncode(lifeLogRawDatas);

    // 요청 본문 구성
    final requestBody = {
      'userId': userId,
      'lifeLogRawDatas': lifeLogRawDatasJson, // JSON 문자열로 전송
      'platformType': platformType,
      'deviceType': deviceType,
      'measLocation': measLocation,
    };

    try {
      final accessToken = await TokenStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token is required. Please authenticate first.');
      }

      final response = await HCApi.post(
        '$_baseUrl/discovery/api/lifelogs/v1/users',
        data: requestBody,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Health data sent successfully');
        // response.data가 null이거나 빈 값인 경우
        if (response.data == null) {
          return null;
        }
        // response.data가 String인 경우 Map으로 변환
        if (response.data is String) {
          final dataString = response.data as String;
          if (dataString.isEmpty) {
            return null;
          }
          return jsonDecode(dataString) as Map<String, dynamic>?;
        }
        return response.data as Map<String, dynamic>?;
      } else if (response.statusCode == 400) {
        print('Error sending health data: ${response.data}');
        // response.data가 null이거나 빈 값인 경우
        if (response.data == null) {
          return null;
        }
        // response.data가 String인 경우 Map으로 변환
        if (response.data is String) {
          final dataString = response.data as String;
          if (dataString.isEmpty) {
            return null;
          }
          return jsonDecode(dataString) as Map<String, dynamic>?;
        }
        return response.data as Map<String, dynamic>?;
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending health data: $e');
      rethrow;
    }
  }

  // 샘플 건강 데이터
  Map<String, dynamic> sampleData = {
    "userId": "a76df653-e04a-44af-a389-f064fc72327a",
    "platformType": "20301102",
    "deviceType": "20401106",
    "measLocation": null,
    "lifeLogRawDatas":
        "{\"data\":[{\"data\":[{\"date\":\"20240409000000+09:00\",\"step\":7311},{\"date\":\"20240408000000+09:00\",\"step\":3737},{\"date\":\"20240407000000+09:00\",\"step\":2948},{\"date\":\"20240410000000+09:00\",\"step\":8500}],\"type\":\"step\",\"platform\":\"android\"},{\"data\":[{\"session\":{\"startDate\":\"20240409020000+09:00\",\"endDate\":\"20240409073000+09:00\",\"stages\":[{\"stage\":1,\"startDate\":\"20240409020000+09:00\",\"endDate\":\"20240409030000+09:00\"},{\"stage\":2,\"startDate\":\"20240409030000+09:00\",\"endDate\":\"20240409050000+09:00\"},{\"stage\":3,\"startDate\":\"20240409050000+09:00\",\"endDate\":\"20240409070000+09:00\"},{\"stage\":1,\"startDate\":\"20240409070000+09:00\",\"endDate\":\"20240409073000+09:00\"}]}},{\"session\":{\"startDate\":\"20240410020000+09:00\",\"endDate\":\"20240410073000+09:00\",\"stages\":[{\"stage\":1,\"startDate\":\"20240410020000+09:00\",\"endDate\":\"20240410030000+09:00\"},{\"stage\":2,\"startDate\":\"20240410030000+09:00\",\"endDate\":\"20240410050000+09:00\"},{\"stage\":3,\"startDate\":\"20240410050000+09:00\",\"endDate\":\"20240410070000+09:00\"},{\"stage\":1,\"startDate\":\"20240410070000+09:00\",\"endDate\":\"20240410073000+09:00\"}]} }],\"type\":\"sleep\",\"platform\":\"android\"},{\"data\":[{\"burned\":0,\"endDate\":\"20240408203413+09:00\",\"distance\":0,\"startDate\":\"20240408203339+09:00\",\"activityType\":7},{\"burned\":200,\"endDate\":\"20240409120000+09:00\",\"distance\":1500,\"startDate\":\"20240409100000+09:00\",\"activityType\":78}],\"type\":\"activity\",\"platform\":\"android\"},{\"data\":[{\"date\":\"20240409200432+09:00\",\"mealType\":2,\"nutrition\":{\"sugar\":0,\"energy\":315,\"sodium\":0.07,\"protein\":6.8,\"totalFat\":1.8,\"cholesterol\":0,\"totalCarbohydrate\":69.4}},{\"date\":\"20240410120000+09:00\",\"mealType\":1,\"nutrition\":{\"sugar\":5,\"energy\":450,\"sodium\":0.1,\"protein\":15.0,\"totalFat\":10.0,\"cholesterol\":30.0,\"totalCarbohydrate\":60.0}}],\"type\":\"food\",\"platform\":\"android\"},{\"data\":[{\"date\":\"20240408094501+09:00\",\"weight\":97.1},{\"date\":\"20240409100000+09:00\",\"weight\":97.5}],\"type\":\"weight\",\"platform\":\"android\"},{\"data\":[{\"date\":\"20240409200453+09:00\",\"systolic\":138,\"diastolic\":80},{\"date\":\"20240410100000+09:00\",\"systolic\":140,\"diastolic\":82}],\"type\":\"bloodPressure\",\"platform\":\"android\"},{\"data\":[{\"date\":\"20240409200446+09:00\",\"glucose\":8.94,\"mealType\":1},{\"date\":\"20240410120000+09:00\",\"glucose\":9.2,\"mealType\":2}],\"type\":\"bloodGlucose\",\"platform\":\"android\"}],\"type\":\"health\",\"userId\":\"3b271f13-9d2e-48f2-b2c1-13e66c1df7ae\",\"platform\":\"android\"}",
  };

  /// 샘플 데이터를 JSON 문자열로 변환
  String getSampleDataAsJsonString() {
    return jsonEncode(sampleData);
  }
}
