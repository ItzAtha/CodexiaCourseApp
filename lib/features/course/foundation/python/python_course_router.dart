import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/course/foundation/python/beginner/views/python_beginner.dart';
import 'package:codexia_course_learning/features/course/foundation/python/python_course.dart';
import 'package:go_router/go_router.dart';

class PythonCourseRouter {
  PythonCourseRouter._();

  static GoRoute initialize() {
    GoRoute pythonCourseRouter = GoRoute(
      path: 'python/:courseId',
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
          path: 'beginner',
          name: 'python-beginner',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: PythonBeginner(),
              transitionDuration: Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'intermediate',
          name: 'python-intermediate',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: PythonBeginner(),
              transitionDuration: Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'expert',
          name: 'python-expert',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: PythonBeginner(),
              transitionDuration: Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: 'master',
          name: 'python-master',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: PythonBeginner(),
              transitionDuration: Duration(milliseconds: 800),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
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
