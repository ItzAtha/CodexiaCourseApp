import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:codexia_course_learning/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../core/app_constants.dart' show AppSizes, ToastAnimations;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormFieldState<String>> emailFieldKey = GlobalKey<FormFieldState<String>>();
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

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
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40.0),
                Text(
                  "Reset Password",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12.0),
                Text(
                  "Enter your email address to receive a password reset link.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 50.0),
                Text(
                  "Email Address",
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  key: emailFieldKey,
                  controller: emailController,
                  style: Theme.of(context).textTheme.labelLarge,
                  decoration: const InputDecoration(hintText: "example@gmail.com"),
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
                const SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () async {
                    if (!emailFieldKey.currentState!.validate()) {
                      return;
                    }

                    String email = emailController.text.trim();
                    await authService.resetPassword(email).then((success) {
                      if (success) {
                        Toastification().show(
                          title: const Text("Reset Link Sent"),
                          description: const Text(
                            "A password reset link has been sent to your email address.",
                          ),
                          type: ToastificationType.success,
                          backgroundColor: Colors.green.shade400,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          autoCloseDuration: ToastAnimations.closeDuration,
                          animationDuration: ToastAnimations.animationDuration,
                        );

                        if (context.mounted) {
                          context.pop();
                        }
                      } else {
                        Toastification().show(
                          title: const Text("Error"),
                          description: Text(authService.getErrorMessage),
                          type: ToastificationType.error,
                          backgroundColor: Colors.red.shade400,
                          icon: const Icon(Icons.error, color: Colors.white),
                          autoCloseDuration: ToastAnimations.closeDuration,
                          animationDuration: ToastAnimations.animationDuration,
                        );
                      }
                    });
                  },
                  child: Text(
                    "Send Reset Link",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
