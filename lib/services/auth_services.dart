import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/manager/firebase_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _addCredentialToFirestore(userCredential);

      FirebaseManager firebaseManager = FirebaseManager();
      await firebaseManager.updateData('Users', userCredential.user!.email!, {
        'displayName': displayName,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = "This email address is already in use.";
      } else if (e.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else if (e.code == 'weak-password') {
        _errorMessage =
            "The password is too weak. Please choose a stronger password.";
      } else {
        _errorMessage =
            e.message ?? 'An unknown error occurred during Email Sign-Up.';
      }
      print('Email/Password Sign-Up failed: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unknown error occurred during Email Sign-Up.';
      print('An error occurred during Email/Password Sign-Up: $e');
    }
    return null;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = "No user found with this email address.";
      } else if (e.code == 'wrong-password') {
        _errorMessage = "Incorrect password. Please try again.";
      } else {
        _errorMessage =
            e.message ?? 'An unknown error occurred during Email Sign-In.';
      }
      print('Email/Password Sign-In failed: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unknown error occurred during Email Sign-In.';
      print('An error occurred during Email/Password Sign-In: $e');
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleAuth.initialize(
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );

      final GoogleSignInAccount googleUser = await _googleAuth.authenticate();

      String? idToken = googleUser.authentication.idToken;
      const List<String> scopes = ['email', 'profile'];

      GoogleSignInClientAuthorization? clientAuth = await googleUser
          .authorizationClient
          .authorizationForScopes(scopes);

      clientAuth ??= await googleUser.authorizationClient.authorizeScopes(
        scopes,
      );
      final String accessToken = clientAuth.accessToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        _errorMessage =
            e.description ?? 'An unknown error occurred during Google Sign-In.';
      }
      print('Google Sign-In failed: ${e.description}');
    } catch (e) {
      _errorMessage = 'An unknown error occurred during Google Sign-In.';
      print('An error occurred during Google Sign-In: $e');
    }
    return null;
  }

  Future<UserCredential?> signInWithGithub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      githubProvider.addScope('user:email');

      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(githubProvider);

      await _addCredentialToFirestore(userCredential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          e.message ?? 'An unknown error occurred during Github Sign-In.';
      print('Github Sign-In failed: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unknown error occurred during Github Sign-In.';
      print('An error occurred during Github Sign-In: $e');
    }
    return null;
  }

  Future<bool> signOut() async {
    try {
      await _googleAuth.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('An error occurred during sign-out: $e');
    }
    return false;
  }

  Future<void> _addCredentialToFirestore(UserCredential userCredential) async {
    FirebaseManager firebaseManager = FirebaseManager();
    Map<String, dynamic>? existingUserData = await firebaseManager.getData(
      "Users",
      userCredential.user!.email!,
    );

    if (existingUserData == null) {
      await firebaseManager.addData("Users", userCredential.user!.email!, {
        "email": userCredential.user!.email!,
        "displayName": userCredential.user!.displayName ?? "Unknown User",
        "createdAt": DateTime.now().toIso8601String(),
        "lastSignIn": DateTime.now().toIso8601String(),
      });
    } else {
      await firebaseManager.addData("Users", userCredential.user!.email!, {
        "lastSignIn": DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    }
  }
}
