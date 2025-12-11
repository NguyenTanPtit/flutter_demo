import 'package:dio/dio.dart';

import '../models/work_entity.dart';
import '../remote/api_client.dart';
import '../remote/api_helper.dart';
import '../remote/resource.dart';
import '../remote/types.dart';

class WorkService extends ApiClient {

  static final WorkService _singleton = WorkService._internal();
  factory WorkService() => _singleton;
  WorkService._internal();

  Future<Resource<BaseResponse<SearchWorkResponse>>> searchWork(int userId) async {
    return getResultWithResponse(() async {

      final payload = {
        "query": {
          "bool": {
            "must": [
              // 1. Điều kiện thời gian
              {
                "range": {
                  "workCreatedDate": {
                    "gte": "now-3M/d"
                  }
                }
              },
              // 2. Điều kiện loại trừ
              {
                "bool": {
                  "must_not": [
                    {
                      "match": {
                        "workStatusId": 0
                      }
                    }
                  ]
                }
              },
              // 3. Danh sách loại công việc
              {
                "terms": {
                  "workTypeId": ["3", "2", "57", "51", "50", "53"]
                }
              },
              // 4. Tiến độ công việc
              {
                "match": {
                  "workProgressId": 7
                }
              },
              {
                "terms": {
                  "workGroupId": [
                    "#GROUPID"
                  ]
                }
              },
              {
                "match": {
                  "workSystemGroup": "QLCTKT"
                }
              }
            ]
          }
        }
      };
      final response = await instance.post<Map<String, dynamic>>(
        '/searchESController/getWorksDashboardItem',
        data: payload,
        queryParameters: { 'userAssignId': userId, 'pageIndex': 1, 'pageSize': 1000 },
      );


      final typedData = BaseResponse.fromJson(
        response.data!,
            (json) => SearchWorkResponse.fromJson(json as Map<String, dynamic>),
      );

      return Response(
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        headers: response.headers,
        data: typedData,
      );
    });
  }

  Future<Resource<BaseResponse<String>>> getTokenByUserName(String userName) async {
    return getResultWithResponse<BaseResponse<String>>(() async {

      final response = await instance.get<Map<String, dynamic>>(
        'generateTokenController/getTokenByUsername',
        queryParameters: {'username': 'tannv5'},
      );

      final typedData = BaseResponse<String>.fromJson(
        response.data!, (json) => json as String
      );

      return Response(
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        headers: response.headers,
        data: typedData,
      );
    });
  }
}

final workService = WorkService();