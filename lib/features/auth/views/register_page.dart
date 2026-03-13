import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/legal/views/privacy_policy_page.dart';
import 'package:codexia_course_learning/features/legal/views/terms_of_service_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../manager/firebase_manager.dart';
import '../../../services/auth_services.dart';
import '../../home/dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  void goToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        reverseTransitionDuration: Duration(milliseconds: 500),
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => DashboardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        forceMaterialTransparency: true,
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome Codexian! Please sign up your account to start your course journey.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
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
                    SizedBox(height: 15.0),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          customBorder: CircleBorder(),
                          child: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        isDense: true,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  children: <TextSpan>[
                    TextSpan(text: "By signing up, you agree to our "),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              reverseTransitionDuration: Duration(milliseconds: 500),
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => TermsOfServicePage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeThroughTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              reverseTransitionDuration: Duration(milliseconds: 500),
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => PrivacyPolicyPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeThroughTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                    ),
                    TextSpan(text: "."),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blue.shade600,
                  ),
                ),
                onPressed: () async {
                  Toastification().dismissAll();
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState!.validate()) {
                    final UserCredential? userCredential = await authService
                        .signUpWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                      usernameController.text
                    );

                    if (userCredential == null) {
                      Toastification().show(
                        title: Text(
                          "Registration Failed",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        description: Text(
                          authService.getErrorMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        backgroundColor: Colors.red.shade400,
                        icon: Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );
                      return;
                    }

                    Toastification().show(
                      title: Text(
                        "Registration Successful",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      description: Text(
                        "Successfully registered with email ${userCredential.user?.email}. You can now log in to your account.",
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.success,
                      backgroundColor: Colors.green.shade400,
                      icon: Icon(Icons.check_circle, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);
                    formKey.currentState!.save();
                  }
                },
                child: Text('Register', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      endIndent: 20.0,
                    ),
                  ),
                  Text(
                    "or",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Expanded(
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      indent: 20.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  final UserCredential? userCredential = await authService
                      .signInWithGoogle();

                  if (userCredential == null) {
                    if (authService.getErrorMessage.isEmpty) return;

                    Toastification().show(
                      title: Text(
                        "Login Failed",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      description: Text(
                        authService.getErrorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.error,
                      backgroundColor: Colors.red.shade400,
                      icon: Icon(Icons.error, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );
                    return;
                  }

                  Toastification().show(
                    title: Text(
                      "Login Successful",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    description: Text(
                      "Welcome, ${userCredential.user?.displayName}!",
                      style: TextStyle(color: Colors.white),
                    ),
                    type: ToastificationType.success,
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    autoCloseDuration: Duration(seconds: 5),
                  );

                  goToHomePage();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/google.png", width: 24.0),
                    SizedBox(width: 10.0),
                    Text(
                      "Continue with Google",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  final UserCredential? userCredential = await authService
                      .signInWithGithub();

                  if (userCredential == null) {
                    Toastification().show(
                      title: Text(
                        "Login Failed",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      description: Text(
                        authService.getErrorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.error,
                      backgroundColor: Colors.red.shade400,
                      icon: Icon(Icons.error, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );
                    return;
                  }

                  Toastification().show(
                    title: Text(
                      "Login Successful",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    description: Text(
                      "Welcome, ${userCredential.user?.displayName}!",
                      style: TextStyle(color: Colors.white),
                    ),
                    type: ToastificationType.success,
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    autoCloseDuration: Duration(seconds: 5),
                  );

                  goToHomePage();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/github.png", width: 24.0),
                    SizedBox(width: 10.0),
                    Text(
                      "Continue with Github",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
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
