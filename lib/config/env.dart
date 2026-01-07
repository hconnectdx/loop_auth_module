/// 환경 변수 관리 클래스
/// 실제 값은 .env 파일에서 읽어오거나 빌드 시 주입해야 합니다.
class Env {
  // 스테이징 환경 변수
  static const String stagingClientId = String.fromEnvironment(
    'STAGING_CLIENT_ID',
    defaultValue: 'YOUR_STAGING_CLIENT_ID',
  );

  static const String stagingClientSecret = String.fromEnvironment(
    'STAGING_CLIENT_SECRET',
    defaultValue: 'YOUR_STAGING_CLIENT_SECRET',
  );

  // 운영 환경 변수
  static const String productionClientId = String.fromEnvironment(
    'PRODUCTION_CLIENT_ID',
    defaultValue: 'YOUR_PRODUCTION_CLIENT_ID',
  );

  static const String productionClientSecret = String.fromEnvironment(
    'PRODUCTION_CLIENT_SECRET',
    defaultValue: 'YOUR_PRODUCTION_CLIENT_SECRET',
  );
}
