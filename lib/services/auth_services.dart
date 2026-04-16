import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/utils/logger.dart';
import '../manager/firebase_manager.dart';

class AuthService {
  final GoogleSignIn _googleAuth = GoogleSignIn.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  String get getErrorMessage => _errorMessage;

  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _addCredentialToFirestore(userCredential, displayName);
      return userCredential;
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'email-already-in-use') {
        _errorMessage = "This email address is already in use.";
      } else if (error.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else if (error.code == 'weak-password') {
        _errorMessage = "The password is too weak. Please choose a stronger password.";
      } else {
        _errorMessage = error.message ?? 'An unknown error occurred during Email Sign-Up.';
      }
      DebugLogger(
        message: 'Email/Password Sign-Up failed: ${error.message}',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    } catch (error, stackTrace) {
      _errorMessage = 'An unknown error occurred during Email Sign-Up.';
      DebugLogger(
        message: 'An error occurred during Email/Password Sign-Up: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return null;
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'user-not-found') {
        _errorMessage = "No user found with this email address.";
      } else if (error.code == 'wrong-password') {
        _errorMessage = "Incorrect password. Please try again.";
      } else {
        _errorMessage = error.message ?? 'An unknown error occurred during Email Sign-In.';
      }
      DebugLogger(
        message: 'Email/Password Sign-In failed: ${error.message}',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    } catch (error, stackTrace) {
      _errorMessage = 'An unknown error occurred during Email Sign-In.';
      DebugLogger(
        message: 'An error occurred during Email/Password Sign-In: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleAuth.initialize(clientId: dotenv.env['GOOGLE_CLIENT_ID']);

      final GoogleSignInAccount googleUser = await _googleAuth.authenticate();

      String? idToken = googleUser.authentication.idToken;
      const List<String> scopes = ['email', 'profile'];

      GoogleSignInClientAuthorization? clientAuth = await googleUser.authorizationClient
          .authorizeScopes(scopes);

      final String accessToken = clientAuth.accessToken;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on GoogleSignInException catch (error, stackTrace) {
      if (error.code != GoogleSignInExceptionCode.canceled) {
        _errorMessage = error.description ?? 'An unknown error occurred during Google Sign-In.';
      }
      DebugLogger(
        message: 'Google Sign-In failed: ${error.description}',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    } catch (error, stackTrace) {
      _errorMessage = 'An unknown error occurred during Google Sign-In.';
      DebugLogger(
        message: 'An error occurred during Google Sign-In: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return null;
  }

  Future<UserCredential?> signInWithGithub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      githubProvider.addScope('user:email');

      final UserCredential userCredential = await _firebaseAuth.signInWithProvider(githubProvider);

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on FirebaseAuthException catch (error, stackTrace) {
      _errorMessage = error.message ?? 'An unknown error occurred during Github Sign-In.';
      DebugLogger(
        message: 'Github Sign-In failed: ${error.message}',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    } catch (error, stackTrace) {
      _errorMessage = 'An unknown error occurred during Github Sign-In.';
      DebugLogger(
        message: 'An error occurred during Github Sign-In: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return null;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'user-not-found') {
        _errorMessage = "No user found with this email address.";
      } else if (error.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else {
        _errorMessage = error.message ?? 'An unknown error occurred during password reset.';
      }
      DebugLogger(
        message: 'Password reset failed: ${error.message}',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    } catch (error, stackTrace) {
      _errorMessage = 'An unknown error occurred during password reset.';
      DebugLogger(
        message: 'An error occurred during password reset: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      await _googleAuth.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (error, stackTrace) {
      DebugLogger(
        message: 'An error occurred during sign-out: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
    return false;
  }

  Future<void> _addCredentialToFirestore(
    UserCredential userCredential, [
    String? displayName = "Anonym User",
  ]) async {
    FirebaseManager firebaseManager = FirebaseManager();
    UserInfo userInfo = userCredential.user!.providerData.first;

    Map<String, dynamic>? existingUserData = await firebaseManager.getData(
      "Users",
      userInfo.email!,
    );

    if (existingUserData == null) {
      await firebaseManager.addData(
        "Users",
        userInfo.email!,
        data: {
          "email": userInfo.email!,
          "displayName": userInfo.displayName ?? displayName,
          "createdAt": DateTime.now().toIso8601String(),
          "lastSignIn": DateTime.now().toIso8601String(),
        },
      );
    } else {
      await firebaseManager.addData(
        "Users",
        userInfo.email!,
        data: {"lastSignIn": DateTime.now().toIso8601String()},
        options: SetOptions(merge: true),
      );
    }
  }
}
