# loop_auth_module

Loop 인증 및 건강 데이터 전송을 위한 Flutter 모듈입니다.

## 설치 방법

`pubspec.yaml` 파일에 다음을 추가하세요:

```yaml
dependencies:
  loop_auth_module:
    git: 
      url: https://github.com/hconnectdx/loop_auth_module.git
      ref: 0.0.1
```


## 주요 기능

- OAuth 2.0 기반 토큰 발급 및 관리
- 외부 클라이언트 토큰 발급
- 토큰 재발급 (Refresh Token)
- 건강 데이터 전송
- 안전한 토큰 저장 (FlutterSecureStorage)

## 사용 방법

### 1. 초기화 및 환경 설정

앱 시작 시 환경을 설정하고 `LoopAuthManager`를 초기화합니다.

```dart
import 'package:loop_auth_module/loop_auth_manager.dart';
import 'package:loop_auth_module/config/environment.dart';

void main() {
  // 스테이징 환경으로 설정
  Environment.setStaging();
  
  // 또는 운영 환경으로 설정
  // Environment.setProduction();
  
  // LoopAuthManager 초기화
  LoopAuthManager().initialize();
  
  runApp(MyApp());
}
```

**환경 설정:**
- `Environment.setDev()`: 개발 서버 (`https://dev-ichms.invitesloop.com`)
- `Environment.setStaging()`: 스테이징 서버 (`https://stg-ichms.invitesloop.com`)
- `Environment.setProduction()`: 운영 서버 (`https://ichms.invitesloop.com`)

### 2. 외부 클라이언트 토큰 발급

사용자 전화번호와 선택적 사용자 ID로 토큰을 발급합니다.

```dart
final authManager = LoopAuthManager();

try {
  final tokenResponse = await authManager.requestExternalClientToken(
    userTel: '+821099991111', // E164 표준 형식
    userId: 'optional-user-id', // 선택사항
  );
  
  print('Access Token: ${tokenResponse.accessToken}');
  print('Refresh Token: ${tokenResponse.refreshToken}');
  print('Expires In: ${tokenResponse.expiresIn}');
} catch (e) {
  print('토큰 발급 실패: $e');
}
```

**파라미터:**
- `userTel` (필수): 사용자 전화번호 (E164 표준 형식, 예: `+821099991111`)
- `userId` (선택): 사용자 ID
- `clientId` (선택): 커스텀 클라이언트 ID
- `clientSecret` (선택): 커스텀 클라이언트 시크릿

**반환값:**
- `TokenResponse`: 액세스 토큰, 리프레시 토큰, 만료 시간 등의 정보를 포함

### 3. 토큰 재발급

리프레시 토큰을 사용하여 새로운 액세스 토큰을 발급합니다.

```dart
final authManager = LoopAuthManager();

try {
  final tokenResponse = await authManager.refreshToken();
  
  print('새로운 Access Token: ${tokenResponse.accessToken}');
} catch (e) {
  print('토큰 재발급 실패: $e');
}
```

**파라미터:**
- `refreshToken` (선택): 리프레시 토큰 (없으면 저장된 토큰 사용)
- `clientId` (선택): 커스텀 클라이언트 ID
- `clientSecret` (선택): 커스텀 클라이언트 시크릿

### 4. 토큰 저장/조회 유틸리티

`TokenStorage` 클래스를 사용하여 토큰을 안전하게 저장하고 조회할 수 있습니다.

```dart
import 'package:loop_auth_module/util/token_storage.dart';

// 액세스 토큰 조회
final accessToken = await TokenStorage.getAccessToken();

// 리프레시 토큰 조회
final refreshToken = await TokenStorage.getRefreshToken();

// 토큰 저장
await TokenStorage.saveTokens(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
);

// 모든 토큰 삭제
await TokenStorage.clearTokens();
```

## API 모델

### TokenResponse

토큰 발급 응답 모델입니다.

```dart
class TokenResponse {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int expiresIn;
  final String? scope;
  final String? clientId;
  final String? userId;
  final bool? isUserProfileRegistered;
  final String? userTimezone;
  final String? languageSeCd;
  final String? loginId;
  final bool? isPasswordChangeRequired;
}
```

## 주의사항

1. **초기화**: 앱 시작 시 반드시 `Environment.setStaging()` 또는 `Environment.setProduction()`을 호출한 후 `LoopAuthManager().initialize()`를 호출해야 합니다.

2. **토큰 저장**: 토큰은 자동으로 `FlutterSecureStorage`에 저장됩니다. 별도로 저장할 필요가 없습니다.

3. **토큰 만료**: 액세스 토큰이 만료되면 `refreshToken()` 메서드를 사용하여 새로운 토큰을 발급받으세요.

4. **에러 처리**: 모든 API 호출은 `try-catch` 블록으로 감싸서 에러를 처리하는 것을 권장합니다.

## 예제

전체 예제는 `example` 디렉토리를 참고하세요.

## 라이선스

이 프로젝트의 라이선스는 LICENSE 파일을 참고하세요.
