import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/course/base_course.dart';
import 'package:codexia_course_learning/features/course/foundation/python/python_course.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/models/course/course_lesson.dart';

class PythonCourseRouter {
  PythonCourseRouter._();

  static GoRoute initialize() {
    GoRoute pythonCourseRouter = GoRoute(
      path: ':courseId',
      name: 'python-course',
      pageBuilder: (context, state) {
        final courseId = state.pathParameters['courseId'] ?? "";

        return CustomTransitionPage(
          key: state.pageKey,
          child: PythonCourse(courseId: courseId),
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: ':levelId/:moduleId',
          name: 'course-module',
          pageBuilder: (context, state) {
            final courseId = state.pathParameters['courseId'] ?? "";
            final levelId = state.pathParameters['levelId'] ?? "";
            final moduleId = state.pathParameters['moduleId'] ?? "";

            final lessons = state.extra as List<CourseLesson>? ?? [];

            return CustomTransitionPage(
              key: state.pageKey,
              child: BaseCourse(
                courseId: courseId,
                level: CourseLevel.values.firstWhere((l) => l.name.toLowerCase() == levelId),
                moduleId: moduleId,
                lessons: lessons,
              ),
              transitionDuration: const Duration(milliseconds: 800),
              reverseTransitionDuration: const Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child,
                );
              },
            );
          },
        ),
      ],
    );

    return pythonCourseRouter;
  }
}
