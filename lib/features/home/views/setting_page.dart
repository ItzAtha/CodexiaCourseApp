import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codexia_course_learning/core/utils/logger.dart';
import 'package:codexia_course_learning/services/firebase_services.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../../../core/app_constants.dart';
import '../../../core/utils/app_info.dart';
import '../../../services/auth_services.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingPageState();
}

enum LanguageOptions { en, id }

class _SettingPageState extends ConsumerState<SettingPage> {
  bool isAvatarLoad = false;
  bool isFingerprintEnable = false;
  bool isThemeOptionOpened = false;
  bool isLanguageOptionOpened = false;

  String appVersion = "";
  LanguageOptions? languageOptions = LanguageOptions.en;

  void updateAvatarLoadStatus(bool status) {
    setState(() => isAvatarLoad = status);
  }

  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  Future<void> loadAppVersion() async {
    final versionInfo = await AppInfo.getAppVersion();
    setState(() {
      appVersion = versionInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p12),
          child: Column(
            children: <Widget>[
              Skeletonizer(
                enabled: authUserState.isLoading,
                enableSwitchAnimation: true,
                child: Column(
                  children: <Widget>[
                    Skeletonizer(
                      enabled: isAvatarLoad,
                      enableSwitchAnimation: true,
                      child: SizedBox(
                        height: 150.0,
                        width: 150.0,
                        child: Stack(
                          alignment: AlignmentGeometry.center,
                          children: <Widget>[
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    authUser?.avatar ??
                                    "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      backgroundColor: const Color(0xFF00CEC9),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              right: 8.0,
                              child: Skeleton.ignore(
                                child: FloatingActionButton.small(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      builder: (context) {
                                        return AvatarSelector(
                                          onStatusChange: updateAvatarLoadStatus,
                                        );
                                      },
                                    );
                                  },
                                  shape: const CircleBorder(),
                                  backgroundColor: AppColors.secondary,
                                  child: const Icon(Icons.edit, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      authUser?.displayName ?? authUser?.username ?? "Guest",
                      style: TextStyle(
                        fontSize: AppSizes.xxlTextSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.labelLarge?.color,
                      ),
                    ),
                    Text(
                      authUser?.email ?? "guest@gmail.com",
                      style: TextStyle(
                        fontSize: AppSizes.mTextSize,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              OutlinedButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.editProfileRoute.name);
                },
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: AppSizes.mTextSize,
                    color: Theme.of(context).textTheme.labelSmall?.color,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "General",
                            style: TextStyle(
                              fontSize: AppSizes.lTextSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() => isThemeOptionOpened = value);
                        },
                        leading: Icon(Icons.color_lens, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Change Theme",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: AnimatedRotation(
                          turns: isThemeOptionOpened ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        tilePadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        iconColor: Colors.grey.shade800,
                        expansionAnimationStyle: const AnimationStyle(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 500),
                        ),
                        children: <Widget>[
                          RadioGroup<AdaptiveThemeMode>(
                            groupValue: AdaptiveTheme.of(context).mode,
                            onChanged: (value) {
                              AdaptiveTheme.of(context).setThemeMode(value!);

                              DebugLogger(
                                message: "Theme Options: $value",
                                level: LogLevel.debug,
                              ).log();
                            },
                            child: Column(
                              children: <Widget>[
                                RadioListTile<AdaptiveThemeMode>(
                                  title: Text(
                                    "Auto",
                                    style: TextStyle(
                                      fontSize: AppSizes.mTextSize,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.system,
                                  activeColor: AppColors.secondary,
                                ),
                                RadioListTile<AdaptiveThemeMode>(
                                  title: Text(
                                    "Light",
                                    style: TextStyle(
                                      fontSize: AppSizes.mTextSize,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.light,
                                  activeColor: AppColors.secondary,
                                ),
                                RadioListTile<AdaptiveThemeMode>(
                                  title: Text(
                                    "Dark",
                                    style: TextStyle(
                                      fontSize: AppSizes.mTextSize,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.dark,
                                  activeColor: AppColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Notifications", level: LogLevel.debug).log();
                        },
                        leading: Icon(
                          Icons.notifications,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Accessibility", level: LogLevel.debug).log();
                        },
                        leading: Icon(
                          Icons.accessibility,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Accessibility",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          DebugLogger(message: "Change Language", level: LogLevel.debug).log();
                          setState(() => isLanguageOptionOpened = value);
                        },
                        leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Change Language",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: AnimatedRotation(
                          turns: isLanguageOptionOpened ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        tilePadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        iconColor: Colors.grey.shade800,
                        expansionAnimationStyle: const AnimationStyle(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 500),
                        ),
                        children: <Widget>[
                          RadioGroup<LanguageOptions>(
                            groupValue: languageOptions,
                            onChanged: (value) {
                              setState(() => languageOptions = value);
                              DebugLogger(
                                message: "Theme Options: $languageOptions",
                                level: LogLevel.debug,
                              ).log();
                            },
                            child: Column(
                              children: <Widget>[
                                RadioListTile<LanguageOptions>(
                                  title: Text(
                                    "English",
                                    style: TextStyle(
                                      fontSize: AppSizes.mTextSize,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: LanguageOptions.en,
                                  activeColor: AppColors.secondary,
                                ),
                                RadioListTile<LanguageOptions>(
                                  title: Text(
                                    "Indonesia",
                                    style: TextStyle(
                                      fontSize: AppSizes.mTextSize,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: LanguageOptions.id,
                                  activeColor: AppColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Security",
                            style: TextStyle(
                              fontSize: AppSizes.lTextSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Enable Fingerprint", level: LogLevel.debug).log();

                          setState(() => isFingerprintEnable = !isFingerprintEnable);
                          DebugLogger(
                            message: "Is Fingerprint Enable? $isFingerprintEnable",
                            level: LogLevel.debug,
                          ).log();
                        },
                        leading: Icon(Icons.fingerprint, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Enable Fingerprint",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isFingerprintEnable,
                            onChanged: (value) {
                              setState(() => isFingerprintEnable = value);
                              DebugLogger(
                                message: "Is Fingerprint Enable? $isFingerprintEnable",
                                level: LogLevel.debug,
                              ).log();
                            },
                            activeTrackColor: AppColors.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Enable 2FA", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.security, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Enable 2FA",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Device Management", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.devices, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Device Management",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "App Permissions", level: LogLevel.debug).log();
                        },
                        leading: Icon(
                          Icons.perm_device_info,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "App Permissions",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Help Center",
                            style: TextStyle(
                              fontSize: AppSizes.lTextSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "FAQ", level: LogLevel.debug).log();
                        },
                        leading: Icon(
                          Icons.question_answer,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "FAQ",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "About Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.info, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Rate Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.star, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Rate Us",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Privacy Policy", level: LogLevel.debug).log();
                          context.pushNamed(AppRoutes.privacyRoute.name);
                        },
                        leading: Icon(Icons.policy, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Term of Service", level: LogLevel.debug).log();
                          context.pushNamed(AppRoutes.tosRoute.name);
                        },
                        leading: Icon(Icons.privacy_tip, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Term of Service",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Contact Support", level: LogLevel.debug).log();
                        },
                        leading: Icon(
                          Icons.contact_support,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Contact Support",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "App Version $appVersion",
                        style: TextStyle(
                          fontSize: AppSizes.sTextSize,
                          color: Theme.of(
                            context,
                          ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Danger Zone",
                            style: TextStyle(
                              fontSize: AppSizes.lTextSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          DebugLogger(message: "Reset Course", level: LogLevel.debug).log();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.dangerZone,
                          minimumSize: const Size(double.infinity, 40.0),
                          side: const BorderSide(color: AppColors.dangerZone),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Reset Course", style: TextStyle(color: AppColors.dangerZone)),
                            SizedBox(width: 10.0),
                            Icon(Icons.restart_alt, color: AppColors.dangerZone),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () async {
                          bool successLogout = await AuthService().signOut();
                          if (successLogout) {
                            Toastification().show(
                              title: const Text("Logout Success"),
                              description: const Text("You have successfully logged out."),
                              type: ToastificationType.success,
                              style: ToastificationStyle.flat,
                              alignment: Alignment.topCenter,
                              autoCloseDuration: ToastAnimations.closeDuration,
                              animationDuration: ToastAnimations.animationDuration,
                            );
                          } else {
                            Toastification().show(
                              title: const Text("Logout Failed"),
                              description: const Text("An error occurred while logging out."),
                              type: ToastificationType.error,
                              style: ToastificationStyle.flat,
                              alignment: Alignment.topCenter,
                              autoCloseDuration: ToastAnimations.closeDuration,
                              animationDuration: ToastAnimations.animationDuration,
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.dangerZone,
                          minimumSize: const Size(double.infinity, 40.0),
                          side: const BorderSide(color: AppColors.dangerZone),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Logout Account", style: TextStyle(color: AppColors.dangerZone)),
                            SizedBox(width: 10.0),
                            Icon(Icons.logout, color: AppColors.dangerZone),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return const AccountDeleteConfirmation();
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.dangerZone,
                          minimumSize: const Size(double.infinity, 40.0),
                          side: const BorderSide(color: AppColors.dangerZone),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Delete Account", style: TextStyle(color: AppColors.dangerZone)),
                            SizedBox(width: 10.0),
                            Icon(Icons.delete_forever, color: AppColors.dangerZone),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarSelector extends ConsumerStatefulWidget {
  const AvatarSelector({super.key, required this.onStatusChange});

  final Function(bool) onStatusChange;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends ConsumerState<AvatarSelector> {
  bool isDeleteButtonPress = false;

  final FirebaseServices services = FirebaseServices();

  Future<void> selectAvatarImage(ImageSource source, {String? avatarPath}) async {
    AuthUser? authUser = ref.read(authUserProvider).value;

    final imagePicker = ImagePicker();
    try {
      final XFile? image = await imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        final croppedImage = await cropAvatarImage(image.path);
        if (croppedImage == null) {
          DebugLogger(message: "Cropped image is null", level: LogLevel.info).log();
          return;
        }

        final uploadProgress = await services.uploadFile(
          croppedImage.path,
          fileName: "${authUser?.username.toLowerCase()}_avatar.jpg",
          savePath: 'Avatars',
          metadata: SettableMetadata(contentType: 'image/jpeg'),
        );
        widget.onStatusChange(true);
        uploadProgress.snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.paused:
              debugPrint("Upload is paused.");
              break;
            case TaskState.running:
              final progress = (100 * taskSnapshot.bytesTransferred) / taskSnapshot.totalBytes;
              debugPrint("Upload is $progress% complete.");
              break;
            case TaskState.success:
              String newPath = await taskSnapshot.ref.getDownloadURL();
              ref.read(authUserProvider.notifier).updateAvatar(newPath);

              Toastification().show(
                title: const Text("Avatar Updated"),
                description: const Text("Your avatar has been updated successfully."),
                type: ToastificationType.success,
                style: ToastificationStyle.flat,
                alignment: Alignment.topCenter,
                autoCloseDuration: ToastAnimations.closeDuration,
                animationDuration: ToastAnimations.animationDuration,
              );

              DebugLogger(message: "Avatar updated successfully", level: LogLevel.info).log();
              widget.onStatusChange(false);
              break;
            case TaskState.canceled:
              debugPrint("Upload was canceled.");
              widget.onStatusChange(false);
              break;
            case TaskState.error:
              debugPrint("Upload failed: ${taskSnapshot.toString()}");
              widget.onStatusChange(false);
              break;
          }
        });
      }
    } catch (error, stackTrace) {
      Toastification().show(
        title: const Text("Error"),
        description: const Text("An error occurred while selecting the image."),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        alignment: Alignment.topCenter,
        autoCloseDuration: ToastAnimations.closeDuration,
        animationDuration: ToastAnimations.animationDuration,
      );

      DebugLogger(
        message: "Error picking image: $error",
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
  }

  Future<void> deleteCurrentAvatar(String? avatarPath) async {
    if (avatarPath == null) {
      DebugLogger(message: "No avatar to delete", level: LogLevel.info).log();
      return;
    }

    bool isDeleted = await services.deleteFile(avatarPath);
    if (isDeleted) {
      ref.read(authUserProvider.notifier).updateAvatar(null);

      if (isDeleteButtonPress) {
        Toastification().show(
          title: const Text("Avatar Deleted"),
          description: const Text("Your avatar has been deleted successfully."),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: ToastAnimations.closeDuration,
          animationDuration: ToastAnimations.animationDuration,
        );
      }

      DebugLogger(message: "Avatar deleted successfully", level: LogLevel.info).log();
    } else {
      if (isDeleteButtonPress) {
        Toastification().show(
          title: const Text("Error"),
          description: const Text("An error occurred while deleting the avatar."),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: ToastAnimations.closeDuration,
          animationDuration: ToastAnimations.animationDuration,
        );
      }

      DebugLogger(message: "Failed to delete avatar", level: LogLevel.info).log();
    }
  }

  Future<CroppedFile?> cropAvatarImage(String filePath) async {
    final ImageCropper cropper = ImageCropper();

    final croppedImage = await cropper.cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Avatar Crop',
          cropStyle: CropStyle.circle,
          showCropGrid: true,
          toolbarColor: const Color(0xFF0984E3),
          toolbarWidgetColor: const Color(0xFFF5F6FA),
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Avatar Crop',
          cropStyle: CropStyle.circle,
          showCancelConfirmationDialog: true,
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    return croppedImage;
  }

  @override
  Widget build(BuildContext context) {
    final userAvatar = ref.watch(authUserProvider.select((value) => value.value?.avatar));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () => selectAvatarImage(ImageSource.camera, avatarPath: userAvatar),
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.camera_alt, size: 40.0),
                  const SizedBox(height: 5.0),
                  Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: AppSizes.mTextSize,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => selectAvatarImage(ImageSource.gallery, avatarPath: userAvatar),
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.photo, size: 40.0),
                  const SizedBox(height: 5.0),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: AppSizes.mTextSize,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() => isDeleteButtonPress = true);

              await deleteCurrentAvatar(userAvatar);

              setState(() => isDeleteButtonPress = false);
            },
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.delete, size: 40.0),
                  const SizedBox(height: 5.0),
                  Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: AppSizes.mTextSize,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountDeleteConfirmation extends ConsumerStatefulWidget {
  const AccountDeleteConfirmation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountDeleteConfirmationState();
}

class _AccountDeleteConfirmationState extends ConsumerState<AccountDeleteConfirmation> {
  bool passwordVisible = false;

  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormFieldState> passwordFieldKey = GlobalKey<FormFieldState>();

  Widget buildEmailField() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 15.0),
        Text(
          "To protect your account, please enter your password to confirm deletion.",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: AppSizes.mTextSize,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          key: passwordFieldKey,
          controller: passwordController,
          obscureText: !passwordVisible,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(
            color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.9),
          ),
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
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? providerId = user?.providerData.firstOrNull?.providerId;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: AppSizes.p16, right: AppSizes.p16, bottom: AppSizes.p24),
      child: Column(
        children: <Widget>[
          Text(
            "Are you sure you want to delete your account? All data include Course "
            "Progress and Chat will be deleted. This action cannot be undone.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: AppSizes.mTextSize,
              color: Theme.of(context).textTheme.labelSmall?.color,
            ),
          ),
          if (providerId == "password") buildEmailField(),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  minimumSize: const Size(120.0, 40.0),
                  side: BorderSide(color: Colors.grey.shade600),
                ),
                child: Text("Cancel", style: TextStyle(color: Colors.grey.shade600)),
              ),
              OutlinedButton(
                onPressed: () async {
                  String? password;
                  if (providerId == "password" && !passwordFieldKey.currentState!.validate()) {
                    return;
                  } else if (providerId == "password") {
                    password = passwordController.text.trim();
                  }

                  final authService = ref.read(authServiceProvider);
                  final bool successDelete = await authService.deleteAccount(password: password);

                  if (successDelete) {
                    Toastification().show(
                      title: const Text("Delete Account Success"),
                      description: const Text("Your account has been deleted successfully."),
                      type: ToastificationType.success,
                      style: ToastificationStyle.flat,
                      alignment: Alignment.topCenter,
                      autoCloseDuration: ToastAnimations.closeDuration,
                      animationDuration: ToastAnimations.animationDuration,
                    );
                  } else {
                    Toastification().show(
                      title: const Text("Delete Account Failed"),
                      description: const Text("An error occurred while deleting your account."),
                      type: ToastificationType.error,
                      style: ToastificationStyle.flat,
                      alignment: Alignment.topCenter,
                      autoCloseDuration: ToastAnimations.closeDuration,
                      animationDuration: ToastAnimations.animationDuration,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.dangerZone,
                  minimumSize: const Size(120.0, 40.0),
                  side: const BorderSide(color: AppColors.dangerZone),
                ),
                child: const Text("Confirm", style: TextStyle(color: AppColors.dangerZone)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
