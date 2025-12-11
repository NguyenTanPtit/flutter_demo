// import 'package:flutter_app/data/models/work_eniity_mapping.dart';
//
// import '../../data/local/database.dart';
// import '../../data/models/work_entity.dart';
// import '../../data/remote/resource.dart'; // Class Resource bạn đã tạo
// import '../../data/services/work_service.dart'; // Import Service đã tạo bài trước
//  // Import extension vừa tạo
//
// class WorkRepository {
//   // Inject WorkService (chứa logic API) chứ không dùng ApiClient trực tiếp nữa
//   final WorkService _workService;
//   final AppDatabase _db;
//
//   WorkRepository(this._workService, this._db);
//
//   Future<Resource<List<WorkEntity>>> getWorks(int userId) async {
//     try {
//       // 1. Gọi API thông qua Service (đã xử lý payload phức tạp)
//       final apiResource = await _workService.searchWork(userId);
//
//
//       if (apiResource is ResourceSuccess) {
//         final responseData = (apiResource as ResourceSuccess).data;
//         final data = responseData?.result?.workList;
//
//         if (data != null && data.isNotEmpty) {
//
//           await _db.transaction(() async {
//
//             await _db.clearWorks();
//
//             for (var entity in data) {
//               await _db.insertOrUpdateWork(entity.toDatabaseModel());
//             }
//           });
//
//           return Resource.success(data);
//         }
//         return Resource.success([]);
//
//       } else if (apiResource is ResourceError) {
//
//         return await _fetchLocalData();
//       }
//
//       return Resource.loading();
//
//     } catch (e) {
//       return await _fetchLocalData();
//     }
//   }
//
//   Future<Resource<List<WorkEntity>>> _fetchLocalData() async {
//     try {
//       final localItems = await _db.getAllWorks();
//
//       if (localItems.isNotEmpty) {
//         final works = localItems.map((e) => e.toEntity()).toList();
//         return Resource.success(works);
//       }
//
//       return Resource.error(Exception("No internet & No local data"));
//     } catch (dbError) {
//       return Resource.error(dbError);
//     }
//   }
// }

import 'package:flutter_app/data/models/work_eniity_mapping.dart';
import '../../data/local/database.dart';
import '../../data/models/work_entity.dart';
import '../../data/remote/resource.dart';
import '../../data/remote/types.dart';
import '../../data/services/work_service.dart';

class WorkRepository {
  final WorkService _workService;
  final AppDatabase _db;

  WorkRepository(this._workService, this._db);

  Future<Resource<List<WorkEntity>>> getWorks(int userId) async {
    try {
      final apiResource = await _workService.searchWork(userId);

      if (apiResource is ResourceSuccess<BaseResponse<SearchWorkResponse>>) {
        final data = apiResource.data?.result?.workList;
        if (data != null && data.isNotEmpty) {
          await _db.transaction(() async {
            await _db.clearWorks();
            for (var entity in data) {
              await _db.insertOrUpdateWork(entity.toDatabaseModel());
            }
          });
          return Resource.success(data);
        }
        return Resource.success([]);
      } else if (apiResource is ResourceError) {
        // FIX: Pass the specific error from the API resource down
        final error = (apiResource as ResourceError).error;
        print(error);
        return await _fetchLocalData(originalError: error);
      }
      return Resource.loading();
    } catch (e) {
      // FIX: Pass the exception from the try-catch block down
      print(e);
      return await _fetchLocalData(originalError: e);
    }
  }

  // FIX: The helper now accepts the original error
  Future<Resource<List<WorkEntity>>> _fetchLocalData({dynamic originalError}) async {
    try {
      final localItems = await _db.getAllWorks();
      if (localItems.isNotEmpty) {
        return Resource.success(localItems.map((e) => e.toEntity()).toList());
      }
      // If no local data, return the actual error that caused the fallback
      return Resource.error(originalError ?? Exception("Network failed & No local data"));
    } catch (dbError) {
      print(dbError);
      return Resource.error(dbError);
    }
  }
}
