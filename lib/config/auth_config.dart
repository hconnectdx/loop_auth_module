import 'env.dart';

/// 인증 환경 타입
enum AuthEnvironment { staging, production }

/// 인증 설정 관리 클래스
class AuthConfig {
  final AuthEnvironment environment;
  final String clientId;
  final String clientSecret;

  const AuthConfig({
    required this.environment,
    required this.clientId,
    required this.clientSecret,
  });

  /// 스테이징 서버 설정
  static AuthConfig get staging => AuthConfig(
    environment: AuthEnvironment.staging,
    clientId: Env.stagingClientId,
    clientSecret: Env.stagingClientSecret,
  );

  /// 운영 서버 설정
  static AuthConfig get production => AuthConfig(
    environment: AuthEnvironment.production,
    clientId: Env.productionClientId,
    clientSecret: Env.productionClientSecret,
  );

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
