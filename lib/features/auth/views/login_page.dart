import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import '../../../core/utils/logger.dart';
import '../../../shared/providers/auth_user_notifier.dart';
import './register_page.dart';
import './reset_password_page.dart';
import '../../../services/auth_services.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool rememberMe = false;
  bool passwordVisible = false;
  late SharedPreferencesAsync sharedPreferences;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  void goToDashboardPage() {
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> loadPreferences() async {
    bool isRemembered = await sharedPreferences.getBool('rememberMe') ?? false;

    setState(() {
      rememberMe = isRemembered;
    });
  }

  @override
  void initState() {
    super.initState();

    const SharedPreferencesAsyncAndroidOptions options = SharedPreferencesAsyncAndroidOptions(
      backend: SharedPreferencesAndroidBackendLibrary.SharedPreferences,
      originalSharedPreferencesOptions: AndroidSharedPreferencesStoreOptions(
        fileName: 'auth_prefs',
      ),
    );

    sharedPreferences = SharedPreferencesAsync(options: options);
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 24.0, color: Theme.of(context).iconTheme.color),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.labelLarge?.color,
                    ),
                  ),
                  Text(
                    "Welcome back Codexian! Please sign in your account to continue your last course.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
                      ),
                      decoration: InputDecoration(hintText: "example@gmail.com"),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            emailController.clear();
                            passwordController.clear();
                            setState(() => rememberMe = false);

                            await Navigator.push(
                              context,
                              PageRouteBuilder(
                                reverseTransitionDuration: Duration(milliseconds: 500),
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    ResetPasswordPage(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                      return SharedAxisTransition(
                                        animation: animation,
                                        secondaryAnimation: secondaryAnimation,
                                        transitionType: SharedAxisTransitionType.horizontal,
                                        child: child,
                                      );
                                    },
                              ),
                            );

                            formKey.currentState?.reset();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 14.0, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          customBorder: CircleBorder(),
                          child: Icon(
                            passwordVisible ? Icons.visibility : Icons.visibility_off,
                            size: 24.0,
                            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 24.0,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() => rememberMe = value ?? false);
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Remember Me",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState!.validate()) {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(emailController.text)
                        .get();

                    if (!userDoc.exists) {
                      Toastification().show(
                        title: Text(
                          "Login Failed",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          "No user found with this email address.",
                          style: TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        alignment: Alignment.topCenter,
                        backgroundColor: Colors.red.shade400,
                        icon: Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );
                      DebugLogger(
                        message: 'No user found with email: ${emailController.text}',
                        level: LogLevel.info,
                      ).log();
                      return;
                    }

                    final UserCredential? userCredential = await authService
                        .signInWithEmailAndPassword(emailController.text, passwordController.text);
                    if (userCredential == null) {
                      Toastification().show(
                        title: Text(
                          "Login Failed",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          authService.getErrorMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        alignment: Alignment.topCenter,
                        backgroundColor: Colors.red.shade400,
                        icon: Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );
                      return;
                    }

                    Toastification().show(
                      title: Text(
                        "Login Successful",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      description: Text(
                        "Welcome back, ${userDoc['displayName']}!",
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.success,
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.green.shade400,
                      icon: Icon(Icons.check_circle, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );

                    goToDashboardPage();
                    ref.invalidate(authUserProvider);
                    await sharedPreferences.setBool('rememberMe', rememberMe);

                    formKey.currentState!.save();
                  }
                },
                child: Text('Login', style: TextStyle(fontSize: 14.0, color: Colors.white)),
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(height: 1.0, thickness: 1.0, endIndent: 20.0)),
                  Text(
                    "or",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  Expanded(child: Divider(height: 1.0, thickness: 1.0, indent: 20.0)),
                ],
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  final UserCredential? userCredential = await authService.signInWithGoogle();

                  if (userCredential == null) {
                    if (authService.getErrorMessage.isEmpty) return;

                    Toastification().show(
                      title: Text(
                        "Login Failed",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      description: Text(
                        authService.getErrorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.error,
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.red.shade400,
                      icon: Icon(Icons.error, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );
                    return;
                  }

                  Toastification().show(
                    title: Text(
                      "Login Successful",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    description: Text(
                      "Welcome back, ${userCredential.user?.displayName}!",
                      style: TextStyle(color: Colors.white),
                    ),
                    type: ToastificationType.success,
                    alignment: Alignment.topCenter,
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    autoCloseDuration: Duration(seconds: 5),
                  );

                  goToDashboardPage();
                  ref.invalidate(authUserProvider);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFCFBFB)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/google.png", width: 24.0),
                    SizedBox(width: 10.0),
                    Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  final UserCredential? userCredential = await authService.signInWithGithub();

                  if (userCredential == null) {
                    Toastification().show(
                      title: Text(
                        "Login Failed",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      description: Text(
                        authService.getErrorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.error,
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.red.shade400,
                      icon: Icon(Icons.error, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );
                    return;
                  }

                  Toastification().show(
                    title: Text(
                      "Login Successful",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    description: Text(
                      "Welcome back, ${userCredential.user?.displayName}!",
                      style: TextStyle(color: Colors.white),
                    ),
                    type: ToastificationType.success,
                    alignment: Alignment.topCenter,
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    autoCloseDuration: Duration(seconds: 5),
                  );

                  goToDashboardPage();
                  ref.invalidate(authUserProvider);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFCFBFB)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/github.png", width: 24.0),
                    SizedBox(width: 10.0),
                    Text(
                      "Continue with Github",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () async {
                      emailController.clear();
                      passwordController.clear();
                      setState(() => rememberMe = false);

                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          reverseTransitionDuration: Duration(milliseconds: 500),
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                        ),
                      );

                      formKey.currentState?.reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Text("Sign Up", style: TextStyle(fontSize: 14, color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
