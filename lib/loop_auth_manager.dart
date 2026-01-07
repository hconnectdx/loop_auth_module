import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hcm_core/core/dio/hc_api.dart';

class LoopAuthManager {
  static final LoopAuthManager _instance = LoopAuthManager._internal();

  factory LoopAuthManager() => _instance;

  LoopAuthManager._internal();

  void printHello() {
    print('Hello, LoopAuthManager!');
  }

  // 클라이언트 시크릿 넘어 받아서 FlutterSecureStorage에 저장
  void setClientSecret(String clientSecret) {
    FlutterSecureStorage().write(key: 'clientSecret', value: clientSecret);
  }

  // 토큰 리프레시
  String refreshToken() {
    // access token 과 refresh token 을 json string 으로 만들어서 리턴
    final response = {
      'accessToken': 'accessToken',
      'refreshToken': 'refreshToken',
    };
    return jsonEncode(response);
  }



  /// 건강데이터 전송
  void sendHealthData(Map<String, dynamic> healthData) {
    final jsonString = jsonEncode(healthData);
    // TODO: 실제 API 호출 구현
    HCApi.dio.post(path: '/health/data', data: jsonString);
    print('Sending health data: $jsonString');
  }

  // 샘플 건강 데이터
  static final Map<String, dynamic> sampleData = {
    "userId": "a76df653-e04a-44af-a389-f064fc72327a",
    "platformType": "20301102",
    "deviceType": "20401106",
    "measLocation": null,
    "lifeLogRawDatas": {
      "data": [
        {
          "data": [
            {"date": "20240409000000+09:00", "step": 7311},
            {"date": "20240408000000+09:00", "step": 3737},
            {"date": "20240407000000+09:00", "step": 2948},
            {"date": "20240406000000+09:00", "step": 491},
            {"date": "20240405000000+09:00", "step": 6289},
            {"date": "20240404000000+09:00", "step": 6554},
            {"date": "20240403000000+09:00", "step": 4987},
            {"date": "20240402000000+09:00", "step": 5493},
            {"date": "20240401000000+09:00", "step": 6438},
            {"date": "20240331000000+09:00", "step": 645},
            {"date": "20240330000000+09:00", "step": 2095},
            {"date": "20240329000000+09:00", "step": 6159},
            {"date": "20240328000000+09:00", "step": 5976},
            {"date": "20240327000000+09:00", "step": 7062},
            {"date": "20240326000000+09:00", "step": 4187},
            {"date": "20240325000000+09:00", "step": 6733},
            {"date": "20240324000000+09:00", "step": 2323},
            {"date": "20240323000000+09:00", "step": 1925},
            {"date": "20240322000000+09:00", "step": 6814},
            {"date": "20240321000000+09:00", "step": 4222},
            {"date": "20240320000000+09:00", "step": 4141},
            {"date": "20240319000000+09:00", "step": 6044},
            {"date": "20240318000000+09:00", "step": 6232},
            {"date": "20240317000000+09:00", "step": 2472},
            {"date": "20240316000000+09:00", "step": 4671},
            {"date": "20240315000000+09:00", "step": 5369},
            {"date": "20240314000000+09:00", "step": 5808},
            {"date": "20240313000000+09:00", "step": 7611},
            {"date": "20240312000000+09:00", "step": 5069},
          ],
          "type": "step",
          "platform": "android",
        },
        {
          "data": [
            {
              "session": {
                "startDate": "20240409020000+09:00",
                "endDate": "20240409073000+09:00",
                "stages": [
                  {
                    "stage": 1,
                    "startDate": "20240409020000+09:00",
                    "endDate": "20240409030000+09:00",
                  },
                  {
                    "stage": 2,
                    "startDate": "20240409030000+09:00",
                    "endDate": "20240409050000+09:00",
                  },
                  {
                    "stage": 3,
                    "startDate": "20240409050000+09:00",
                    "endDate": "20240409070000+09:00",
                  },
                  {
                    "stage": 1,
                    "startDate": "20240409070000+09:00",
                    "endDate": "20240409073000+09:00",
                  },
                ],
              },
            },
            {
              "session": {
                "startDate": "20240408000200+09:00",
                "endDate": "20240408073000+09:00",
                "stages": [
                  {
                    "stage": 1,
                    "startDate": "20240408000200+09:00",
                    "endDate": "20240408003000+09:00",
                  },
                  {
                    "stage": 2,
                    "startDate": "20240408003000+09:00",
                    "endDate": "20240408050000+09:00",
                  },
                  {
                    "stage": 3,
                    "startDate": "20240408050000+09:00",
                    "endDate": "20240408070000+09:00",
                  },
                  {
                    "stage": 1,
                    "startDate": "20240408070000+09:00",
                    "endDate": "20240408073000+09:00",
                  },
                ],
              },
            },
            {
              "session": {
                "startDate": "20240407013000+09:00",
                "endDate": "20240407094000+09:00",
                "stages": [
                  {
                    "stage": 1,
                    "startDate": "20240407013000+09:00",
                    "endDate": "20240407020000+09:00",
                  },
                  {
                    "stage": 2,
                    "startDate": "20240407020000+09:00",
                    "endDate": "20240407060000+09:00",
                  },
                  {
                    "stage": 3,
                    "startDate": "20240407060000+09:00",
                    "endDate": "20240407090000+09:00",
                  },
                  {
                    "stage": 1,
                    "startDate": "20240407090000+09:00",
                    "endDate": "20240407094000+09:00",
                  },
                ],
              },
            },
            {
              "session": {
                "startDate": "20240404021000+09:00",
                "endDate": "20240404073000+09:00",
                "stages": [
                  {
                    "stage": 1,
                    "startDate": "20240404021000+09:00",
                    "endDate": "20240404030000+09:00",
                  },
                  {
                    "stage": 2,
                    "startDate": "20240404030000+09:00",
                    "endDate": "20240404050000+09:00",
                  },
                  {
                    "stage": 3,
                    "startDate": "20240404050000+09:00",
                    "endDate": "20240404070000+09:00",
                  },
                  {
                    "stage": 1,
                    "startDate": "20240404070000+09:00",
                    "endDate": "20240404073000+09:00",
                  },
                ],
              },
            },
            {
              "session": {
                "startDate": "20240404231000+09:00",
                "endDate": "20240405061000+09:00",
                "stages": [
                  {
                    "stage": 1,
                    "startDate": "20240404231000+09:00",
                    "endDate": "20240405000000+09:00",
                  },
                  {
                    "stage": 2,
                    "startDate": "20240405000000+09:00",
                    "endDate": "20240405030000+09:00",
                  },
                  {
                    "stage": 3,
                    "startDate": "20240405030000+09:00",
                    "endDate": "20240405060000+09:00",
                  },
                  {
                    "stage": 1,
                    "startDate": "20240405060000+09:00",
                    "endDate": "20240405061000+09:00",
                  },
                ],
              },
            },
          ],
          "type": "sleep",
          "platform": "android",
        },
        {
          "data": [
            {
              "burned": 0,
              "endDate": "20240408203413216+09:00",
              "distance": 0,
              "startDate": "20240408203339581+09:00",
              "activityType": 7,
            },
            {
              "burned": 183.55,
              "endDate": "20240328215416030+09:00",
              "distance": 1310.48,
              "startDate": "20240328214221925+09:00",
              "activityType": 78,
            },
            {
              "burned": 156.91000000000003,
              "endDate": "20240326100508598+09:00",
              "distance": 1170.2900000000002,
              "startDate": "20240326095438592+09:00",
              "activityType": 78,
            },
            {
              "burned": 168.96,
              "endDate": "20240316181144843+09:00",
              "distance": 0,
              "startDate": "20240316180509843+09:00",
              "activityType": 7,
            },
            {
              "burned": 185.14000000000001,
              "endDate": "20240316184513647+09:00",
              "distance": 0,
              "startDate": "20240316183445267+09:00",
              "activityType": 7,
            },
            {
              "burned": 252.33999999999997,
              "endDate": "20240316185751847+09:00",
              "distance": 0,
              "startDate": "20240316184627607+09:00",
              "activityType": 7,
            },
            {
              "burned": 75.13000000000001,
              "endDate": "20240316194709236+09:00",
              "distance": 226.14999999999998,
              "startDate": "20240316194337456+09:00",
              "activityType": 7,
            },
            {
              "burned": 143.54,
              "endDate": "20240316195619979+09:00",
              "distance": 413.8800000000001,
              "startDate": "20240316194832819+09:00",
              "activityType": 7,
            },
            {
              "burned": 545.47,
              "endDate": "20240316201101485+09:00",
              "distance": 529.87,
              "startDate": "20240316195724805+09:00",
              "activityType": 7,
            },
            {
              "burned": 192,
              "endDate": "20240313131925652+09:00",
              "distance": 1390.44,
              "startDate": "20240313130737980+09:00",
              "activityType": 78,
            },
          ],
          "type": "activity",
          "platform": "android",
        },
        {
          "data": [
            {
              "date": "20240409200432989+09:00",
              "mealType": 2,
              "nutrition": {
                "sugar": 0,
                "energy": 315,
                "sodium": 0.07,
                "protein": 6.8,
                "totalFat": 1.8,
                "cholesterol": 0,
                "totalCarbohydrate": 69.4,
              },
            },
            {
              "date": "20240408181707653+09:00",
              "mealType": 2,
              "nutrition": {
                "sugar": 0,
                "energy": 315,
                "sodium": 0.07,
                "protein": 6.8,
                "totalFat": 1.8,
                "cholesterol": 0,
                "totalCarbohydrate": 69.4,
              },
            },
            {
              "date": "20240405171555261+09:00",
              "mealType": 2,
              "nutrition": {
                "sugar": 0,
                "energy": 315,
                "sodium": 0.07,
                "protein": 6.8,
                "totalFat": 1.8,
                "cholesterol": 0,
                "totalCarbohydrate": 69.4,
              },
            },
          ],
          "type": "food",
          "platform": "android",
        },
        {
          "data": [
            {"date": "20240408094501737+09:00", "weight": 97.1},
            {"date": "20240407171712740+09:00", "weight": 96.1},
            {"date": "20240405172134666+09:00", "weight": 95.1},
            {"date": "20240404164620830+09:00", "weight": 94},
          ],
          "type": "weight",
          "platform": "android",
        },
        {
          "data": [
            {
              "date": "20240409200453426+09:00",
              "systolic": 138,
              "diastolic": 80,
            },
            {
              "date": "20240408094522245+09:00",
              "systolic": 125,
              "diastolic": 80,
            },
            {
              "date": "20240407171728210+09:00",
              "systolic": 122,
              "diastolic": 80,
            },
            {
              "date": "20240405172202317+09:00",
              "systolic": 121,
              "diastolic": 80,
            },
            {
              "date": "20240403143352888+09:00",
              "systolic": 120,
              "diastolic": 80,
            },
            {
              "date": "20240329153034904+09:00",
              "systolic": 119,
              "diastolic": 80,
            },
          ],
          "type": "bloodPressure",
          "platform": "android",
        },
        {
          "data": [
            {"date": "20240409200446438+09:00", "glucose": 8.94, "mealType": 1},
            {"date": "20240408094510111+09:00", "glucose": 8.6, "mealType": 1},
            {"date": "20240407171722283+09:00", "glucose": 8.55, "mealType": 1},
            {"date": "20240405172144499+09:00", "glucose": 8.6, "mealType": 1},
            {"date": "20240403143344817+09:00", "glucose": 5.55, "mealType": 1},
            {"date": "20240329153053490+09:00", "glucose": 6.05, "mealType": 3},
            {"date": "20240329153102708+09:00", "glucose": 5.33, "mealType": 1},
          ],
          "type": "bloodGlucose",
          "platform": "android",
        },
      ],
    },
    "type": "health",
    "userId": "3b271f13-9d2e-48f2-b2c1-13e66c1df7ae",
    "platform": "android",
  };

  /// 샘플 데이터를 JSON 문자열로 변환
  String getSampleDataAsJsonString() {
    return jsonEncode(sampleData);
  }
}
