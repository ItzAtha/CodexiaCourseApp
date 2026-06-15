import 'package:codexia_course_learning/shared/models/user_course_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class UserLevelProgressConverter
    implements JsonConverter<List<UserLevelProgress>, Map<String, dynamic>> {
  const UserLevelProgressConverter();

  @override
  List<UserLevelProgress> fromJson(Map<String, dynamic> json) {
    return json.entries.map((entry) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value as Map);
      data['levelId'] = entry.key;

      return UserLevelProgress.fromJson(data);
    }).toList();
  }

  @override
  Map<String, dynamic> toJson(List<UserLevelProgress> list) {
    final Map<String, dynamic> map = {};
    for (var item in list) {
      final data = item.toJson();
      data.remove('levelId');
      map[item.levelId] = data;
    }
    return map;
  }
}
