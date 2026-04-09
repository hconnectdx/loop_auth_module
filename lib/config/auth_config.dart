import 'env.dart';

/// 인증 환경 타입
enum AuthEnvironment { dev, staging, production }

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

  static AuthConfig get dev {
    return AuthConfig(
      environment: AuthEnvironment.dev,
      clientId: Env.devClientId,
      clientSecret: Env.devClientSecret,
      baseUrl: 'https://dev-ichms.invitesloop.com',
    );
  }

  /// 스테이징 서버 설정
  static AuthConfig get staging {
    return AuthConfig(
      environment: AuthEnvironment.staging,
      clientId: Env.stagingClientId,
      clientSecret: Env.stagingClientSecret,
      baseUrl: 'https://stg-ichms.invitesloop.com',
    );
  }

  /// 운영 서버 설정
  static AuthConfig get production {
    return AuthConfig(
      environment: AuthEnvironment.production,
      clientId: Env.productionClientId,
      clientSecret: Env.productionClientSecret,
      baseUrl: 'https://ichms.invitesloop.com',
    );
  }

  /// 현재 환경에 따른 설정 반환
  static AuthConfig getCurrentConfig(AuthEnvironment env) {
    switch (env) {
      case AuthEnvironment.dev:
        return dev;
      case AuthEnvironment.staging:
        return staging;
      case AuthEnvironment.production:
        return production;
    }
  }
}
