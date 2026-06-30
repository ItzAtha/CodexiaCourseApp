import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:toastification/toastification.dart';

import '../../../core/app_constants.dart' hide AppColors;
import '../../../core/utils/logger.dart';
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
    bool isDarkMode = false;
    final themeMode = AdaptiveTheme.of(context).mode;
    if (themeMode == AdaptiveThemeMode.system) {
      isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    } else {
      isDarkMode = themeMode == AdaptiveThemeMode.dark;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, size: 24.0, color: Theme.of(context).iconTheme.color),
          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
        systemOverlayStyle: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Sign In", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 12.0),
                    Text(
                      "Welcome back Codexian! Please sign in your account to continue your last course.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Email Address",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: emailController,
                        style: Theme.of(context).textTheme.labelLarge,
                        decoration: const InputDecoration(hintText: "example@gmail.com"),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUnfocus,
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
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Text(
                            "Password",
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              emailController.clear();
                              passwordController.clear();
                              setState(() => rememberMe = false);

                              await context.pushNamed('reset-password');

                              formKey.currentState?.reset();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: Theme.of(context).textTheme.labelLarge,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            customBorder: const CircleBorder(),
                            child: Icon(
                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                              size: 24.0,
                              color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.8),
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
                        onChanged: (value) async {
                          setState(() => rememberMe = value ?? false);
                          await sharedPreferences.setBool('rememberMe', rememberMe);
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text("Remember Me", style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                const SizedBox(height: 10.0),
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
                          title: const Text(
                            "Login Failed",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          description: const Text(
                            "No user found with this email address.",
                            style: TextStyle(color: Colors.white),
                          ),
                          type: ToastificationType.error,
                          alignment: Alignment.topCenter,
                          backgroundColor: Colors.red.shade400,
                          icon: const Icon(Icons.error, color: Colors.white),
                          autoCloseDuration: ToastAnimations.closeDuration,
                          animationDuration: ToastAnimations.animationDuration,
                        );

                        DebugLogger(
                          message: 'No user found with email: ${emailController.text}',
                          level: LogLevel.info,
                        ).log();
                        return;
                      }

                      final authService = ref.read(authServiceProvider);
                      final UserCredential? userCredential = await authService
                          .signInWithEmailAndPassword(
                            emailController.text,
                            passwordController.text,
                          );
                      if (userCredential == null) {
                        await sharedPreferences.remove('rememberMe');

                        Toastification().show(
                          title: const Text(
                            "Login Failed",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          description: Text(
                            authService.getErrorMessage,
                            style: const TextStyle(color: Colors.white),
                          ),
                          type: ToastificationType.error,
                          alignment: Alignment.topCenter,
                          backgroundColor: Colors.red.shade400,
                          icon: const Icon(Icons.error, color: Colors.white),
                          autoCloseDuration: ToastAnimations.closeDuration,
                          animationDuration: ToastAnimations.animationDuration,
                        );
                        return;
                      }

                      Toastification().show(
                        title: const Text(
                          "Login Successful",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          "Welcome back, ${userDoc['displayName']}!",
                          style: const TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.success,
                        alignment: Alignment.topCenter,
                        backgroundColor: Colors.green.shade400,
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        autoCloseDuration: ToastAnimations.closeDuration,
                        animationDuration: ToastAnimations.animationDuration,
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    const Expanded(child: Divider(height: 1.0, thickness: 1.0, endIndent: 20.0)),
                    Text(
                      "or",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
                      ),
                    ),
                    const Expanded(child: Divider(height: 1.0, thickness: 1.0, indent: 20.0)),
                  ],
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    final UserCredential? userCredential = await authService.signInWithGoogle();

                    if (userCredential == null) {
                      if (authService.getErrorMessage.isEmpty) return;

                      Toastification().show(
                        title: const Text(
                          "Login Failed",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          authService.getErrorMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        alignment: Alignment.topCenter,
                        backgroundColor: Colors.red.shade400,
                        icon: const Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: ToastAnimations.closeDuration,
                        animationDuration: ToastAnimations.animationDuration,
                      );
                      return;
                    }

                    Toastification().show(
                      title: const Text(
                        "Login Successful",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      description: Text(
                        "Welcome back, ${userCredential.user?.displayName}!",
                        style: const TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.success,
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.green.shade400,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      autoCloseDuration: ToastAnimations.closeDuration,
                      animationDuration: ToastAnimations.animationDuration,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCFBFB)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/google.png", width: 24.0),
                      const SizedBox(width: 10.0),
                      Text(
                        "Continue with Google",
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    final UserCredential? userCredential = await authService.signInWithGithub();

                    if (userCredential == null) {
                      Toastification().show(
                        title: const Text(
                          "Login Failed",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          authService.getErrorMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        alignment: Alignment.topCenter,
                        backgroundColor: Colors.red.shade400,
                        icon: const Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: ToastAnimations.closeDuration,
                        animationDuration: ToastAnimations.animationDuration,
                      );
                      return;
                    }

                    Toastification().show(
                      title: const Text(
                        "Login Successful",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      description: Text(
                        "Welcome back, ${userCredential.user?.displayName}!",
                        style: const TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.success,
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.green.shade400,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      autoCloseDuration: ToastAnimations.closeDuration,
                      animationDuration: ToastAnimations.animationDuration,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCFBFB)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/github.png", width: 24.0),
                      const SizedBox(width: 10.0),
                      Text(
                        "Continue with Github",
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () async {
                        emailController.clear();
                        passwordController.clear();

                        await context.pushNamed(AppRoutes.registerRoute.name);

                        formKey.currentState?.reset();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
