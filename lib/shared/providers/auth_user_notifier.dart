import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/logger.dart';
import '../../manager/firebase_manager.dart';
import '../models/user_course_progress.dart';

part 'auth_user_notifier.g.dart';

@riverpod
class AuthUserNotifier extends _$AuthUserNotifier {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Future<AuthUser> build() async {
    return _loadUserData();
  }

  Future<AuthUser> _loadUserData() async {
    AuthUser authUser = AuthUser(
      userId: Random.secure().nextInt(1 << 32).toString(),
      username: "Guest",
      email: "guest@example.com",
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final String userId = currentUser.uid;
      final (usersData, courseProgressData) = await (
        usersCollection.doc(userId).get(),
        usersCollection.doc(userId).collection('CourseProgress').get(),
      ).wait;

      if (usersData.exists) {
        List<Map<String, dynamic>> coursesProgressRaw = [];
        final Map<String, dynamic> userData = usersData.data() as Map<String, dynamic>;

        if (courseProgressData.docs.isNotEmpty) {
          for (final courseProgress in courseProgressData.docs) {
            Map<String, dynamic> progressData = courseProgress.data();
            final Map<String, dynamic> levelsGroupMap = {};

            final levelProgressData = await usersCollection
                .doc(userId)
                .collection('CourseProgress')
                .doc(courseProgress.id)
                .collection('Levels')
                .get();

            for (final levelProgress in levelProgressData.docs) {
              levelsGroupMap[levelProgress.id] = levelProgress.data();
            }

            progressData['levels'] = levelsGroupMap;
            coursesProgressRaw.add(progressData);
          }
        }
        userData['coursesProgress'] = coursesProgressRaw;

        try {
          authUser = AuthUser.fromJson(userData);
          Map<String, dynamic> authUserDetail = authUser.toJson();

          DebugLogger(message: authUserDetail, level: LogLevel.trace).log();
        } catch (error, stackTrace) {
          DebugLogger(
            message: 'Error parsing user data: $error',
            stackTrace: stackTrace,
            level: LogLevel.error,
          ).log();
        }
      } else {
        DebugLogger(
          message: 'User data not found for user ID: $userId',
          level: LogLevel.info,
        ).log();
      }
    } else {
      DebugLogger(message: 'No user is currently signed in.', level: LogLevel.info).log();
    }

    return authUser;
  }

  Future<void> refetchProgress() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || state.value == null) return;

    final String userId = currentUser.uid;
    final courseProgressData = await usersCollection.doc(userId).collection('CourseProgress').get();

    List<UserCourseProgress> compiledProgressList = [];

    if (courseProgressData.docs.isNotEmpty) {
      for (final courseProgress in courseProgressData.docs) {
        Map<String, dynamic> progressData = courseProgress.data();
        final Map<String, dynamic> levelsGroupMap = {};

        final levelProgressData = await usersCollection
            .doc(userId)
            .collection('CourseProgress')
            .doc(courseProgress.id)
            .collection('Levels')
            .get();

        for (final levelProgress in levelProgressData.docs) {
          levelsGroupMap[levelProgress.id] = levelProgress.data();
        }

        progressData['levels'] = levelsGroupMap;
        compiledProgressList.add(UserCourseProgress.fromJson(progressData));
      }
    }

    state = AsyncData(state.value!.copyWith(coursesProgress: compiledProgressList));
  }

  Future<void> updateDisplayName(String? displayName) async {
    FirebaseManager manager = FirebaseManager();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (state.value != null && currentUser != null) {
      final String userId = currentUser.uid;
      state = AsyncData(state.value!.copyWith(displayName: displayName));

      await manager.updateData('Users', userId, newData: {'displayName': state.value!.displayName});
    }
  }

  Future<void> updateAvatar(String? avatar) async {
    FirebaseManager manager = FirebaseManager();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (state.value != null && currentUser != null) {
      final String userId = currentUser.uid;
      state = AsyncData(state.value!.copyWith(avatar: avatar ?? currentUser.photoURL));

      await manager.updateData(
        'Users',
        userId,
        newData: {'avatar': avatar ?? currentUser.photoURL},
      );
    }
  }

  Future<void> updateCourses(UserCourseProgress updatedProgress) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (state.value == null || currentUser == null) return;

    final String userId = currentUser.uid;
    final List<UserCourseProgress> currentProgressList = List<UserCourseProgress>.from(
      state.value!.coursesProgress ?? [],
    );

    int index = currentProgressList.indexWhere((item) => item.courseId == updatedProgress.courseId);

    if (index != -1) {
      currentProgressList[index] = updatedProgress;
    } else {
      currentProgressList.add(updatedProgress);
    }

    state = AsyncData(state.value!.copyWith(coursesProgress: currentProgressList));

    final courseDocRef = usersCollection
        .doc(userId)
        .collection('CourseProgress')
        .doc(updatedProgress.courseId);

    final Map<String, dynamic> rootPayload = updatedProgress.toJson();
    rootPayload.remove('levels');

    try {
      await courseDocRef.set(rootPayload, SetOptions(merge: true));

      for (final level in updatedProgress.levels) {
        final Map<String, dynamic> levelPayload = level.toJson();
        levelPayload.remove('levelId');

        await courseDocRef
            .collection('Levels')
            .doc(level.levelId)
            .set(levelPayload, SetOptions(merge: true));
      }
    } catch (error, stackTrace) {
      DebugLogger(
        message: 'Failed to sync course progress to Firestore: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
  }

  Future<bool> deleteCourseProgress() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (state.value == null || currentUser == null) return false;

    final String userId = currentUser.uid;

    try {
      final courseProgressCollection = usersCollection.doc(userId).collection('CourseProgress');
      final courseProgressDocs = await courseProgressCollection.get();

      for (final courseProgressDoc in courseProgressDocs.docs) {
        final levelsCollection = courseProgressCollection
            .doc(courseProgressDoc.id)
            .collection('Levels');
        final levelsDocs = await levelsCollection.get();

        for (final levelDoc in levelsDocs.docs) {
          await levelDoc.reference.delete();
        }

        await courseProgressDoc.reference.delete();
      }

      state = AsyncData(state.value!.copyWith(coursesProgress: null));
      return true;
    } catch (error, stackTrace) {
      DebugLogger(
        message: 'Failed to delete course progress: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
      return false;
    }
  }
}
