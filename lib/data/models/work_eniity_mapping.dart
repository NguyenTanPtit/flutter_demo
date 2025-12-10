// file: ../data/mappers/work_mapper.dart
import 'dart:convert';
import '../../data/local/database.dart'; // Import class DB của Drift/Floor/Sqflite
import '../../data/models/work_entity.dart';

extension WorkEntityMapping on WorkEntity {
  // Convert API Model -> DB Model
  WorkItem toDatabaseModel() {
    return WorkItem(
      workId: workId, // Giả sử id là workId
      workCode: workCode ?? '',
      workDescription: workDescription,
      workStatusName: workStatusName,
      workStaffName: workStaffName,
      workCreatedDate: workCreatedDate,
      // Cache lại toàn bộ cục JSON để sau này lấy ra cho tiện nếu model thay đổi
      jsonContent: jsonEncode(toJson()),
    );
  }
}

extension WorkItemMapping on WorkItem {
  // Convert DB Model -> Domain/API Model
  WorkEntity toEntity() {
    if (jsonContent != null) {
      try {
        return WorkEntity.fromJson(jsonDecode(jsonContent!) as Map<String, dynamic>);
      } catch (e) {
        // Fallback nếu json lỗi
      }
    }
    // Fallback nếu không có jsonContent
    return WorkEntity(
      workId: workId,
      workCode: workCode,
      workDescription: workDescription,
      workStatusName: workStatusName,
      workStaffName: workStaffName,
      workCreatedDate: workCreatedDate,
    );
  }
}