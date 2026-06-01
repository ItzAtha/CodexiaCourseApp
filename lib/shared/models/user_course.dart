class UserCourseProgress {
  final String courseId;
  final String lastAccessedLevel;
  final String lastAccessedModule;
  final String lastAccessedLesson;
  final DateTime lastAccessedAt;
  final List<UserLevelProgress> levelProgress;
  final List<UserModuleProgress> moduleProgress;

  UserCourseProgress({
    required this.courseId,
    required this.lastAccessedLevel,
    required this.lastAccessedModule,
    required this.lastAccessedLesson,
    required this.lastAccessedAt,
    required this.levelProgress,
    required this.moduleProgress,
  });

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) {
    return UserCourseProgress(
      courseId: json['courseId'],
      lastAccessedLevel: json['lastAccessedLevel'],
      lastAccessedModule: json['lastAccessedModule'],
      lastAccessedLesson: json['lastAccessedLesson'],
      lastAccessedAt: DateTime.parse(json['lastAccessedAt']),
      levelProgress: (json['levelProgress'] as Map<String, dynamic>).entries
          .map((level) => UserLevelProgress.fromEntry(level))
          .toList(),
      moduleProgress: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'lastAccessedLevel': lastAccessedLevel,
      'lastAccessedModule': lastAccessedModule,
      'lastAccessedLesson': lastAccessedLesson,
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
      'levelProgress': Map.fromEntries(
        levelProgress.map((level) => MapEntry(level.levelName, level.toMap())),
      ),
      'moduleProgress': Map.fromEntries(
        moduleProgress.map((module) => MapEntry(module.moduleId, module.toMap())),
      ),
    };
  }
}

class UserLevelProgress {
  final String levelName;
  final List<String> completedModules;
  final int totalModules;

  UserLevelProgress({
    required this.levelName,
    required this.completedModules,
    required this.totalModules,
  });

  factory UserLevelProgress.fromEntry(MapEntry<String, dynamic> entry) {
    return UserLevelProgress(
      levelName: entry.key,
      completedModules: List<String>.from(entry.value['completedModules']),
      totalModules: entry.value['totalModules'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'completedModules': completedModules, 'totalModules': totalModules};
  }
}

class UserModuleProgress {
  final String moduleId;
  final List<String> completedLessons;
  final bool isComplete;

  UserModuleProgress({
    required this.moduleId,
    required this.completedLessons,
    required this.isComplete,
  });

  factory UserModuleProgress.fromEntry(MapEntry<String, dynamic> entry) {
    return UserModuleProgress(
      moduleId: entry.key,
      completedLessons: List<String>.from(entry.value['completedModules']),
      isComplete: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'completedModules': completedLessons, 'totalModules': isComplete};
  }
}
