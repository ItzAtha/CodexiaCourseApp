import 'package:codexia_course_learning/shared/enums/course_level.dart';

enum CourseType {
  programmingFoundation("Programming Foundation"),
  databaseStructures("Database Structures"),
  frameworkDevelopment("Framework Development");

  final String name;

  const CourseType(this.name);
}

enum LessonFeature { hasInteractive, hasSandbox }
enum ContentType {
  explain("Explain"),
  hint("Hint"),
  important("Important"),
  conclusion("Conclusion");

  final String name;

  const ContentType(this.name);
}

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
  Map<CourseLevel, List<CourseModule>>? modules;

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
    Map<CourseLevel, List<CourseModule>>? parsedModules;

    if (json['modules'] != null) {
      if (json['modules'] is Map) {
        parsedModules = {};
        (json['modules'] as Map<String, dynamic>).forEach((levelKey, modulesList) {
          CourseLevel level = CourseLevel.values.firstWhere(
            (e) => e.name == levelKey,
            orElse: () => CourseLevel.beginner,
          );
          parsedModules![level] = (modulesList as List)
              .map((module) => CourseModule.fromJson(module))
              .toList();
        });
      }
    }

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
      parsedModules ?? {},
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
      'modules': modules != null
          ? modules!.map((level, moduleList) => MapEntry(
                level.name.toLowerCase(),
                moduleList.map((module) => module.toJson()).toList(),
              ))
          : {},
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
    Map<CourseLevel, List<CourseModule>>? Function()? modules,
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
  String moduleId;
  int order;
  String title;
  String description;
  int expAmount;
  Duration duration;
  List<CourseLesson> lessons;

  CourseModule(
      this.moduleId,
    this.order,
    this.title,
    this.description,
    this.expAmount,
    this.duration,
    this.lessons,
  );

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    List<String> durationParts = (json['duration'] as String).split(':');
    int hours = int.tryParse(durationParts[0]) ?? 0;
    int minutes = int.tryParse(durationParts[1]) ?? 0;
    Duration duration = Duration(hours: hours, minutes: minutes);

    return CourseModule(
      json['id'],
      json['order'],
      json['title'],
      json['description'],
      json['exp'],
      duration,
      json['lessons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'order': order,
      'title': title,
      'description': description,
      'exp': expAmount,
      'duration': duration.toString().split('.').first.padLeft(8, '0'),
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class CourseLesson {
  String id;
  String title;
  Map<ContentType, String> content;
  List<LessonFeature> features;

  CourseLesson(this.id, this.title, this.content, this.features);

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      json['id'],
      json['title'],
      (json['content'] as Map<String, dynamic>).map((key, value) => MapEntry(ContentType.values.firstWhere((e) => e.name == key), value)),
      (json['features'] as List)
          .map((feature) => LessonFeature.values.firstWhere((e) => e.name == feature))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content.map((key, value) => MapEntry(key.name, value)),
      'features': features.map((feature) => feature.name).toList(),
    };
  }
}
