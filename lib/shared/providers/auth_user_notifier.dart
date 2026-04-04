import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
              final Map<String, dynamic> userData =
                  documentSnapshot.data() as Map<String, dynamic>;

              DocumentReference userAvatarRef = userData['avatar'];
              DocumentSnapshot avatarSnapshot = await userAvatarRef.get();
              userData.update(
                'avatar',
                (value) => UserAvatar.fromJson(
                  avatarSnapshot.data() as Map<String, dynamic>,
                ),
              );

              try {
                authUser = AuthUser.fromJson(userData);
                print(
                  'User Data with ID $userId: $userData with avatar ${avatarSnapshot.data()}',
                );
              } catch (e) {
                print('Error parsing user data: $e');
              }
            } else {
              print('User data not found for user ID: $userId');
            }
          })
          .catchError((error) {
            print('Error getting user data: $error');
          });
    } else {
      print('No user is currently signed in.');
    }

    return authUser;
  }

  Future<void> updateDisplayName(String displayName) async {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(displayName: displayName));
    }
  }

  void updateAvatar(UserAvatar avatar) {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(avatar: avatar));
    }
  }

  void logout() {
    state = AsyncData(AuthUser.defaultUser());
  }
}
