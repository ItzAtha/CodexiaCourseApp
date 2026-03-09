import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/features/auth/views/register_page.dart';
import 'package:codexia_course_learning/features/auth/views/reset_password_page.dart';
import 'package:codexia_course_learning/features/home/views/home_page.dart';
import 'package:codexia_course_learning/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool passwordVisible = false;
  late SharedPreferencesAsync sharedPreferences;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  void goToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        reverseTransitionDuration: Duration(milliseconds: 500),
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
  void initState() {
    super.initState();

    const SharedPreferencesAsyncAndroidOptions options =
        SharedPreferencesAsyncAndroidOptions(
          backend: SharedPreferencesAndroidBackendLibrary.SharedPreferences,
          originalSharedPreferencesOptions:
              AndroidSharedPreferencesStoreOptions(fileName: 'auth_prefs'),
        );

    sharedPreferences = SharedPreferencesAsync(options: options);
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
                    "Sign In",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome back Codexian! Please sign in your account to continue your last course.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
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
                    Row(
                      children: <Widget>[
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                reverseTransitionDuration: Duration(
                                  milliseconds: 500,
                                ),
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ResetPasswordPage(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return SharedAxisTransition(
                                        animation: animation,
                                        secondaryAnimation: secondaryAnimation,
                                        transitionType:
                                            SharedAxisTransitionType.horizontal,
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
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
                        setState(() async {
                          rememberMe = value ?? false;
                          await sharedPreferences.setBool(
                            'rememberMe',
                            rememberMe,
                          );
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text("Remember Me", style: TextStyle(fontSize: 14.0)),
                ],
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
                    final userDoc = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(emailController.text)
                        .get();

                    if (!userDoc.exists) {
                      Toastification().show(
                        title: Text(
                          "Login Failed",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        description: Text(
                          "No user found with this email address.",
                          style: TextStyle(color: Colors.white),
                        ),
                        type: ToastificationType.error,
                        backgroundColor: Colors.red.shade400,
                        icon: Icon(Icons.error, color: Colors.white),
                        autoCloseDuration: Duration(seconds: 5),
                      );
                      print(
                        'No user found with email: ${emailController.text}',
                      );
                      return;
                    }

                    final UserCredential? userCredential = await authService
                        .signInWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        );
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
                        "Welcome back, ${userCredential.user?.displayName}!",
                        style: TextStyle(color: Colors.white),
                      ),
                      type: ToastificationType.success,
                      backgroundColor: Colors.green.shade400,
                      icon: Icon(Icons.check_circle, color: Colors.white),
                      autoCloseDuration: Duration(seconds: 5),
                    );

                    goToHomePage();
                    formKey.currentState!.save();
                  }
                },
                child: Text('Login', style: TextStyle(color: Colors.white)),
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
                      "Welcome back, ${userCredential.user?.displayName}!",
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
                      "Welcome back, ${userCredential.user?.displayName}!",
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
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          reverseTransitionDuration: Duration(
                            milliseconds: 500,
                          ),
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RegisterPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
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
