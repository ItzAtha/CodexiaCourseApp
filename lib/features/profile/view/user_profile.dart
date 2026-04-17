import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../shared/models/auth_user.dart';
import '../../../shared/providers/auth_user_notifier.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    final authUserState = ref.read(authUserProvider);
    AuthUser? authUser = authUserState.value;

    if (authUser != null) {
      emailController.text = authUser.email;
      displayNameController.text = authUser.displayName ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x990984E3), Color(0xFF0984E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            ClipOval(
              child: Image.network(
                authUser?.avatar?.avatarPath ??
                    "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                width: 110.0,
                height: 110.0,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF00CEC9),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "DisplayName",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.labelSmall?.color,
                  ),
                ),
                TextField(
                  controller: displayNameController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 15.0),
                Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.labelSmall?.color,
                  ),
                ),
                TextFormField(
                  key: emailFieldKey,
                  controller: emailController,
                  readOnly: true,
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
                SizedBox(height: 15.0),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (emailFieldKey.currentState?.validate() ?? false) {
                  if ((authUser?.displayName ?? "") != displayNameController.text) {
                    ref
                        .read(authUserProvider.notifier)
                        .updateDisplayName(
                          displayNameController.text.isNotEmpty ? displayNameController.text : null,
                        );

                    Toastification().show(
                      context: context,
                      title: Text("Profile updated successfully"),
                      type: ToastificationType.success,
                      style: ToastificationStyle.minimal,
                      alignment: Alignment.topCenter,
                      autoCloseDuration: Duration(seconds: 2),
                      animationDuration: Duration(milliseconds: 500),
                    );
                  }
                  context.pop();
                }
              },
              style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(double.infinity, 40.0))),
              child: Text("Save", style: TextStyle(fontSize: 14.0, color: Colors.white)),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
