import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../core/app_constants.dart' hide AppRoutes;
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
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    authUser?.avatar ?? "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                      value: downloadProgress.progress,
                      backgroundColor: const Color(0xFF00CEC9),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
              ),
            ),
            const SizedBox(height: 40.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "DisplayName",
                  style: TextStyle(
                    fontSize: AppSizes.mTextSize,
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
                const SizedBox(height: 15.0),
                Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: AppSizes.mTextSize,
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
              ],
            ),
            const SizedBox(height: 30.0),
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
                      title: const Text("Profile updated successfully"),
                      type: ToastificationType.success,
                      style: ToastificationStyle.minimal,
                      alignment: Alignment.topCenter,
                      autoCloseDuration: ToastAnimations.closeDuration,
                      animationDuration: ToastAnimations.animationDuration,
                    );
                  }
                  context.pop();
                }
              },
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 40.0)),
              ),
              child: const Text("Save", style: TextStyle(fontSize: 14.0, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
