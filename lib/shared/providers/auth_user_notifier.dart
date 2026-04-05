import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/logger.dart';
import '../../manager/firebase_manager.dart';
import '../models/user_avatar.dart';

part 'auth_user_notifier.g.dart';

@Riverpod(keepAlive: true)
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
      final String? userId = currentUser.providerData[0].email;

      await usersCollection
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              final Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;

              DocumentReference userAvatarRef = userData['avatar'];
              DocumentSnapshot avatarSnapshot = await userAvatarRef.get();
              userData.update(
                'avatar',
                (value) => UserAvatar.fromJson(avatarSnapshot.data() as Map<String, dynamic>),
              );

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
          })
          .catchError((error) {
            DebugLogger(
              message: 'Error getting user data: $error',
              stackTrace: StackTrace.current,
              level: LogLevel.error,
            ).log();
          });
    } else {
      DebugLogger(message: 'No user is currently signed in.', level: LogLevel.info).log();
    }

    return authUser;
  }

  Future<void> updateDisplayName(String displayName) async {
    FirebaseManager firestore = FirebaseManager();

    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(displayName: displayName));

      await firestore.updateData('Users', state.value!.email, {
        'displayName': state.value!.displayName,
      });
    }
  }

  Future<void> updateAvatar(UserAvatar avatar) async {
    FirebaseManager firestore = FirebaseManager();

    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(avatar: avatar));

      await firestore.updateData('Avatars', state.value!.email, state.value!.avatar!.toJson());
    }
  }

  void logout() {
    state = AsyncData(AuthUser.defaultUser());
  }
}
