import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/logger.dart';
import '../../manager/firebase_manager.dart';
import '../models/user_course.dart';

part 'auth_user_notifier.g.dart';

@riverpod
class AuthUserNotifier extends _$AuthUserNotifier {
  @override
  Future<AuthUser> build() async {
    return _loadUserData();
  }

  Future<AuthUser> _loadUserData() async {
    AuthUser authUser = AuthUser.defaultUser();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference usersCollection = firestore.collection('Users');

    if (currentUser != null) {
      final String userId = currentUser.uid;
      String provider = currentUser.providerData.isNotEmpty
          ? currentUser.providerData[0].providerId
          : 'anonymous';

      final String docId = '${userId}_$provider';
      final (usersData, coursesData) = await (
        usersCollection.doc(docId).get(),
        usersCollection.doc(docId).collection('Courses').get(),
      ).wait;

      if (usersData.exists) {
        final Map<String, dynamic> userData = usersData.data() as Map<String, dynamic>;

        if (coursesData.docs.isNotEmpty) {
          userData.addAll({
            'courses': UserCourseList.fromJson(coursesData.docs.map((doc) => doc.data()).toList()),
          });
        }

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

  Future<void> updateDisplayName(String? displayName) async {
    FirebaseManager manager = FirebaseManager();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (state.value != null && currentUser != null) {
      final String userId = currentUser.uid;
      String provider = currentUser.providerData.isNotEmpty
          ? currentUser.providerData[0].providerId
          : 'anonymous';

      final String docId = '${userId}_$provider';
      state = AsyncData(state.value!.copyWith(displayName: () => displayName));

      await manager.updateData('Users', docId, newData: {'displayName': state.value!.displayName});
    }
  }

  Future<void> updateAvatar(String? avatar) async {
    FirebaseManager manager = FirebaseManager();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (state.value != null && currentUser != null) {
      final String userId = currentUser.uid;
      String provider = currentUser.providerData.isNotEmpty
          ? currentUser.providerData[0].providerId
          : 'anonymous';

      final String docId = '${userId}_$provider';
      state = AsyncData(state.value!.copyWith(avatar: () => avatar));

      await manager.updateData('Users', docId, newData: {'avatar': avatar});
    }
  }

  Future<void> updateCourses(UserCourseList courses) async {
    FirebaseManager manager = FirebaseManager();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (state.value != null && currentUser != null) {
      final String userId = currentUser.uid;
      String provider = currentUser.providerData.isNotEmpty
          ? currentUser.providerData[0].providerId
          : 'anonymous';

      final String docId = '${userId}_$provider';
      state = AsyncData(state.value!.copyWith(courses: courses));

      for (var course in courses.courseList) {
        await manager.updateData(
          'Users',
          docId,
          subCollectionQuery: [
            SubCollectionQuery(
              collection: 'Courses',
              docId: course.courseId,
              data: courses.toJson(),
            ),
          ],
        );
      }
    }
  }
}
