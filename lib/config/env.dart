/// 환경 변수 관리 클래스
/// 하드코딩된 값 사용
class Env {
  // 스테이징 환경 변수
  static const String stagingClientId = '297e1e34-27a6-4043-8813-0a0c62dccf7b';
  static const String stagingClientSecret =
      '4a1f9d7c6d45107af1c01603737b6855932b959c9d5ee03109da5a079883b0bd';

  // 운영 환경 변수
  static const String productionClientId =
      '8f84ee04-9a9e-403d-b69f-b0deefcf3272';
  static const String productionClientSecret =
      '2a05b18a08991b97737e43db6ff81d836eed5e205f1435f8b21ad77bcab37902';
}
