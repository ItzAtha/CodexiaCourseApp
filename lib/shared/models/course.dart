import 'package:codexia_course_learning/shared/enums/course_level.dart';

enum CourseType {
  programmingFoundation("Programming Foundation"),
  databaseStructures("Database Structures"),
  frameworkDevelopment("Framework Development");

  final String name;

  const CourseType(this.name);
}

enum LessonFeature { hasInteractive, hasSandbox }

class Course {
  String courseId;
  String name;
  String description;
  double rating;
  double popular;
  CourseType type;
  List<CourseLevel> levels;
  DateTime createdAt;
  bool isActive;
  List<CourseModule>? modules;

  Course(
    this.courseId,
    this.name,
    this.description,
    this.rating,
    this.popular,
    this.type,
    this.levels,
    this.createdAt,
    this.isActive,
    this.modules,
  );

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json['id'],
      json['title'],
      json['description'],
      json['rating'].toDouble(),
      json['popular'].toDouble(),
      CourseType.values.firstWhere((e) => e.name == json['type']),
      (json['level'] as List)
          .map((level) => CourseLevel.values.firstWhere((e) => e.name == level))
          .toList(),
      DateTime.parse(json['createdAt']),
      json['isActive'],
      json['modules'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': courseId,
      'title': name,
      'description': description,
      'rating': rating,
      'popular': popular,
      'type': type.name,
      'level': levels.map((level) => level.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'modules': modules?.map((course) => course.toJson()).toList(),
    };
  }

  Course copyWith({
    String Function()? courseId,
    String Function()? name,
    String Function()? description,
    double Function()? rating,
    double Function()? popular,
    CourseType Function()? type,
    List<CourseLevel> Function()? levels,
    DateTime Function()? createdAt,
    bool Function()? isActive,
    List<CourseModule>? Function()? modules,
  }) {
    return Course(
      courseId != null ? courseId() : this.courseId,
      name != null ? name() : this.name,
      description != null ? description() : this.description,
      rating != null ? rating() : this.rating,
      popular != null ? popular() : this.popular,
      type != null ? type() : this.type,
      levels != null ? levels() : this.levels,
      createdAt != null ? createdAt() : this.createdAt,
      isActive != null ? isActive() : this.isActive,
      modules != null ? modules() : this.modules,
    );
  }
}

class CourseModule {
  int order;
  String title;
  String description;
  int expAmount;
  double progress;
  Duration duration;
  int totalLessons;
  bool isLocked;

  // List<CourseLesson> lessons;

  CourseModule(
    this.order,
    this.title,
    this.description,
    this.expAmount,
    this.progress,
    this.duration,
    this.totalLessons,
    this.isLocked,
    /*this.lessons*/
  );

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    List<String> durationParts = (json['duration'] as String).split(':');
    int hours = int.tryParse(durationParts[0]) ?? 0;
    int minutes = int.tryParse(durationParts[1]) ?? 0;
    Duration duration = Duration(hours: hours, minutes: minutes);

    return CourseModule(
      json['order'],
      json['title'],
      json['description'],
      json['exp'],
      json['progress'],
      duration,
      json['totalLessons'],
      json['isLocked'],
      // (json['lessons'] as List)
      //     .map((lesson) => CourseLesson.fromJson(lesson))
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'description': description,
      'exp': expAmount,
      'duration': duration.toString().split('.').first.padLeft(8, '0'),
      // 'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

// TODO: Implement this code to save Course Modules Lessons
// class CourseLesson {
//   String content;
//   List<LessonFeature> features;
//
//   CourseLesson(this.content, this.features);
//
//   factory CourseLesson.fromJson(Map<String, dynamic> json) {
//     return CourseLesson(
//       json['content'],
//       (json['features'] as List)
//           .map((feature) => LessonFeature.values.firstWhere((e) => e.name == feature))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'content': content,
//       'features': features.map((feature) => feature.name).toList(),
//     };
//   }
// }
