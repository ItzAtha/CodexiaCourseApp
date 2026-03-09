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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, forceMaterialTransparency: true),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter your email address to receive a password reset link.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              Text(
                "Email Address",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
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
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blue.shade600,
                  ),
                ),
                onPressed: () async {
                  String email = emailController.text.trim();

                  await authService.resetPassword(email).then((success) {
                    if (success) {
                      Toastification().show(
                        title: Text("Reset Link Sent"),
                        description: Text("A password reset link has been sent to your email address."),
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
