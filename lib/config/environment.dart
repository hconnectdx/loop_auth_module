import 'auth_config.dart';

/// 환경 설정 관리 클래스
class Environment {
  static AuthEnvironment _currentEnvironment = AuthEnvironment.staging;

  /// 현재 환경 설정
  static AuthEnvironment get currentEnvironment => _currentEnvironment;

  /// 환경 설정 변경
  static void setEnvironment(AuthEnvironment env) {
    _currentEnvironment = env;
  }

  /// 현재 환경에 따른 인증 설정 반환
  static AuthConfig get authConfig {
    return AuthConfig.getCurrentConfig(_currentEnvironment);
  }

  /// 스테이징 환경으로 설정
  static void setStaging() {
    _currentEnvironment = AuthEnvironment.staging;
  }

  /// 운영 환경으로 설정
  static void setProduction() {
    _currentEnvironment = AuthEnvironment.production;
  }

  /// 개발 환경으로 설정
  static void setDev() {
    _currentEnvironment = AuthEnvironment.dev;
  }

  /// 현재 환경이 스테이징인지 확인
  static bool get isStaging => _currentEnvironment == AuthEnvironment.staging;

  /// 현재 환경이 운영인지 확인
  static bool get isProduction =>
      _currentEnvironment == AuthEnvironment.production;

  /// 현재 환경이 개발인지 확인
  static bool get isDev => _currentEnvironment == AuthEnvironment.dev;
}
