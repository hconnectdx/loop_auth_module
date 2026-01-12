import 'env.dart';

/// 인증 환경 타입
enum AuthEnvironment { staging, production }

/// 인증 설정 관리 클래스
class AuthConfig {
  final AuthEnvironment environment;
  final String clientId;
  final String clientSecret;
  final String baseUrl;

  const AuthConfig({
    required this.environment,
    required this.clientId,
    required this.clientSecret,
    required this.baseUrl,
  });

  /// 스테이징 서버 설정
  static AuthConfig get staging {
    return AuthConfig(
      environment: AuthEnvironment.staging,
      clientId: Env.stagingClientId,
      clientSecret: Env.stagingClientSecret,
      baseUrl: 'https://stg.ichms.ai',
    );
  }

  /// 운영 서버 설정
  static AuthConfig get production {
    return AuthConfig(
      environment: AuthEnvironment.production,
      clientId: Env.productionClientId,
      clientSecret: Env.productionClientSecret,
      baseUrl: 'https://ichms.ai',
    );
  }

  /// 현재 환경에 따른 설정 반환
  static AuthConfig getCurrentConfig(AuthEnvironment env) {
    switch (env) {
      case AuthEnvironment.staging:
        return staging;
      case AuthEnvironment.production:
        return production;
    }
  }
}
