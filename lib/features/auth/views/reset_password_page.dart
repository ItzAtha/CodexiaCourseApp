import 'package:codexia_course_learning/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

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
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.0),
              Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter your email address to receive a password reset link.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
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
                  color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
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
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();

                  await authService.resetPassword(email).then((success) {
                    if (success) {
                      Toastification().show(
                        title: Text("Reset Link Sent"),
                        description: Text(
                          "A password reset link has been sent to your email address.",
                        ),
                        type: ToastificationType.success,
                        backgroundColor: Colors.green.shade400,
                        icon: Icon(Icons.check_circle, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } else {
                      Toastification().show(
                        title: Text("Error"),
                        description: Text(authService.getErrorMessage),
                        type: ToastificationType.error,
                        backgroundColor: Colors.red.shade400,
                        icon: Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );
                    }
                  });
                },
                child: Text("Send Reset Link", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
