import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/logger.dart';
import '../../features/chat/models/chat_message.dart';
import '../../features/chat/models/user_chat_channel.dart';
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
        userData['coursesProgress'] = [...coursesProgressRaw];
        coursesProgressRaw.clear();

        try {
          authUser = AuthUser.fromJson(userData);
          DebugLogger(message: authUser.toJson(), level: LogLevel.trace).log();
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

  Future<void> loadChatChannels(ChatType type) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || state.value == null) return;

    final String userId = currentUser.uid;
    final chatChannelsData = await usersCollection
        .doc(userId)
        .collection('ChatChannels')
        .where('type', isEqualTo: type.name.toUpperCase())
        .get();

    List<UserChatChannel> chatChannelList = [];

    if (chatChannelsData.docs.isNotEmpty) {
      for (final chatChannel in chatChannelsData.docs) {
        Map<String, dynamic> channelData = chatChannel.data();
        chatChannelList.add(UserChatChannel.fromJson(channelData));
      }
    }

    state = AsyncData(state.value!.copyWith(chatChannels: chatChannelList));
  }

  Future<DocumentSnapshot?> loadChatMessages(
    String channelId, {
    DocumentSnapshot? lastDocumentLoad,
    int maxLoad = 6,
  }) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || state.value == null) return null;

    final List<UserChatChannel> chatChannelList = state.value!.chatChannels ?? [];
    final List<ChatMessage> messageList = [];

    if (chatChannelList.isNotEmpty) {
      UserChatChannel? chatChannel = chatChannelList
          .where((channel) => channel.channelId == channelId)
          .firstOrNull;
      if (chatChannel != null) {
        final String userId = currentUser.uid;
        Query chatMessagesQuery = usersCollection
            .doc(userId)
            .collection('ChatChannels')
            .doc(channelId)
            .collection('ChatMessages')
            .orderBy('timestamp', descending: true)
            .limit(maxLoad);

        if (lastDocumentLoad != null) {
          chatMessagesQuery = chatMessagesQuery.startAfterDocument(lastDocumentLoad);
        }

        final chatMessagesData = await chatMessagesQuery.get();
        if (chatMessagesData.docs.isNotEmpty) {
          for (var chatMessage in chatMessagesData.docs) {
            Map<String, dynamic> data = chatMessage.data() as Map<String, dynamic>;
            messageList.add(ChatMessage.fromJson(data));
          }

          messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          final updatedChannels = chatChannelList.map((channel) {
            if (channel.channelId == channelId) {
              return channel.copyWith(messages: [...messageList]);
            }
            return channel;
          }).toList();

          state = AsyncData(state.value!.copyWith(chatChannels: updatedChannels));
          return chatMessagesData.docs.last;
        }
      }
    }
    return null;
  }

  Future<void> unloadChatChannels() async {
    state = AsyncData(state.value!.copyWith(chatChannels: []));
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
