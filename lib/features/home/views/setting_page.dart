import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:codexia_course_learning/core/utils/logger.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../../../services/auth_services.dart';
import '../../../services/cloudinary_services.dart';
import '../../../shared/models/user_avatar.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingPageState();
}

enum LanguageOptions { en, id }

class _SettingPageState extends ConsumerState<SettingPage> {
  bool isFingerprintEnable = false;
  bool isThemeOptionOpened = false;
  bool isLanguageOptionOpened = false;

  LanguageOptions? languageOptions = LanguageOptions.en;

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.orientation == Orientation.portrait ? 80.0 : 10.0),
              Skeletonizer(
                enabled: authUserState.isLoading,
                enableSwitchAnimation: true,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        children: <Widget>[
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
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Skeleton.ignore(
                              child: FloatingActionButton.small(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) {
                                      return AvatarSelector();
                                    },
                                  );
                                },
                                shape: CircleBorder(),
                                backgroundColor: Color(0xFF00CEC9),
                                child: Icon(Icons.edit, color: Color(0xFFF5F6FA)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      authUser?.displayName ?? authUser?.username ?? "Guest",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.labelLarge?.color,
                      ),
                    ),
                    Text(
                      authUser?.email ?? "guest@gmail.com",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              OutlinedButton(
                onPressed: () {
                  context.pushNamed('edit-profile');
                },
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.labelSmall?.color,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "General",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() => isThemeOptionOpened = value);
                        },
                        leading: Icon(Icons.color_lens, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Change Theme",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: AnimatedRotation(
                          turns: isThemeOptionOpened ? 0.25 : 0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        tilePadding: EdgeInsets.only(left: 10.0, right: 10.0),
                        iconColor: Colors.grey.shade800,
                        expansionAnimationStyle: AnimationStyle(
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
                                      fontSize: 16.0,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.system,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<AdaptiveThemeMode>(
                                  title: Text(
                                    "Light",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.light,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<AdaptiveThemeMode>(
                                  title: Text(
                                    "Dark",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: AdaptiveThemeMode.dark,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1.0, height: 1.0),
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
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
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
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          DebugLogger(message: "Change Language", level: LogLevel.debug).log();
                          setState(() => isLanguageOptionOpened = value);
                        },
                        leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Change Language",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: AnimatedRotation(
                          turns: isLanguageOptionOpened ? 0.25 : 0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        tilePadding: EdgeInsets.only(left: 10.0, right: 10.0),
                        iconColor: Colors.grey.shade800,
                        expansionAnimationStyle: AnimationStyle(
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
                                      fontSize: 16.0,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: LanguageOptions.en,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<LanguageOptions>(
                                  title: Text(
                                    "Indonesia",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Theme.of(context).textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  value: LanguageOptions.id,
                                  activeColor: Color(0xFF00CEC9),
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
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Security",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      SizedBox(height: 10.0),
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
                            fontSize: 16.0,
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
                            activeTrackColor: Color(0xFF00CEC9),
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 5.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Enable 2FA", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.security, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Enable 2FA",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Device Management", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.devices, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Device Management",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
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
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Help Center",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      SizedBox(height: 10.0),
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
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "About Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.info, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Rate Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.star, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Rate Us",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Privacy Policy", level: LogLevel.debug).log();
                          context.pushNamed('privacy-policy');
                        },
                        leading: Icon(Icons.policy, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Term of Service", level: LogLevel.debug).log();
                          context.pushNamed('tos');
                        },
                        leading: Icon(Icons.privacy_tip, color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "Term of Service",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
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
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Danger Zone",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelMedium?.color,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(child: Divider(thickness: 1.2, height: 20.0)),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          DebugLogger(message: "Reset Course", level: LogLevel.debug).log();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 40.0),
                          side: BorderSide(color: Colors.redAccent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Reset Course", style: TextStyle(color: Colors.redAccent)),
                            SizedBox(width: 10.0),
                            Icon(Icons.restart_alt, color: Colors.redAccent),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () async {
                          DebugLogger(message: "Logout Account", level: LogLevel.debug).log();
                          bool successLogout = await AuthService().signOut();

                          if (successLogout) {
                            Toastification().show(
                              title: Text("Logout Success"),
                              description: Text("You have successfully logged out."),
                              type: ToastificationType.success,
                              style: ToastificationStyle.flat,
                              alignment: Alignment.topCenter,
                              autoCloseDuration: Duration(seconds: 3),
                              animationDuration: Duration(milliseconds: 500),
                            );
                          } else {
                            Toastification().show(
                              title: Text("Logout Failed"),
                              description: Text("An error occurred while logging out."),
                              type: ToastificationType.error,
                              style: ToastificationStyle.flat,
                              alignment: Alignment.topCenter,
                              autoCloseDuration: Duration(seconds: 3),
                              animationDuration: Duration(milliseconds: 500),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 40.0),
                          side: BorderSide(color: Colors.redAccent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Logout Account", style: TextStyle(color: Colors.redAccent)),
                            SizedBox(width: 10.0),
                            Icon(Icons.logout, color: Colors.redAccent),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () {
                          DebugLogger(message: "Delete Account", level: LogLevel.debug).log();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 40.0),
                          side: BorderSide(color: Colors.redAccent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Delete Account", style: TextStyle(color: Colors.redAccent)),
                            SizedBox(width: 10.0),
                            Icon(Icons.delete_forever, color: Colors.redAccent),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 90.0),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarSelector extends ConsumerStatefulWidget {
  const AvatarSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends ConsumerState<AvatarSelector> {
  bool isDeleteButtonPress = false;

  Future<void> selectAvatarImage(ImageSource source, {String? publicId}) async {
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

        (String?, String?)? userAvatar = await CloudinaryServices().uploadImage(croppedImage.path);

        if (userAvatar != null) {
          DebugLogger(message: "Public Id: ${userAvatar.$1}", level: LogLevel.info).log();
          DebugLogger(message: "URL: ${userAvatar.$2}", level: LogLevel.info).log();

          await deleteCurrentAvatar(publicId);
          UserAvatar avatar = UserAvatar(publicId: userAvatar.$1!, avatarPath: userAvatar.$2!);
          ref.read(authUserProvider.notifier).updateAvatar(avatar);

          Toastification().show(
            title: Text("Avatar Updated"),
            description: Text("Your avatar has been updated successfully."),
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            alignment: Alignment.topCenter,
            autoCloseDuration: Duration(seconds: 3),
            animationDuration: Duration(milliseconds: 500),
          );

          DebugLogger(message: "Avatar updated successfully", level: LogLevel.info).log();
        }
      }
    } catch (error, stackTrace) {
      Toastification().show(
        title: Text("Error"),
        description: Text("An error occurred while selecting the image."),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        alignment: Alignment.topCenter,
        autoCloseDuration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 500),
      );

      DebugLogger(
        message: "Error picking image: $error",
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
    }
  }

  Future<void> deleteCurrentAvatar(String? publicId) async {
    if (publicId == null || publicId.isEmpty) {
      DebugLogger(message: "No avatar to delete", level: LogLevel.info).log();
      return;
    }

    bool isDeleted = await CloudinaryServices().deleteImage(publicId);

    if (isDeleted) {
      ref.read(authUserProvider.notifier).updateAvatar(UserAvatar(publicId: ''));
      if (isDeleteButtonPress) {
        Toastification().show(
          title: Text("Avatar Deleted"),
          description: Text("Your avatar has been deleted successfully."),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: Duration(seconds: 3),
          animationDuration: Duration(milliseconds: 500),
        );
      }

      DebugLogger(message: "Avatar deleted successfully", level: LogLevel.info).log();
    } else {
      if (isDeleteButtonPress) {
        Toastification().show(
          title: Text("Error"),
          description: Text("An error occurred while deleting the avatar."),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: Duration(seconds: 3),
          animationDuration: Duration(milliseconds: 500),
        );
      }

      DebugLogger(message: "Failed to delete avatar", level: LogLevel.info).log();
    }
  }

  Future<CroppedFile?> cropAvatarImage(String filePath) async {
    final ImageCropper cropper = ImageCropper();

    final croppedImage = await cropper.cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Avatar Crop',
          cropStyle: CropStyle.circle,
          showCropGrid: true,
          toolbarColor: Color(0xFF0984E3),
          toolbarWidgetColor: Color(0xFFF5F6FA),
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
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () =>
                selectAvatarImage(ImageSource.camera, publicId: authUser?.avatar?.publicId),
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt, size: 40.0),
                  SizedBox(height: 5.0),
                  Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () =>
                selectAvatarImage(ImageSource.gallery, publicId: authUser?.avatar?.publicId),
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.photo, size: 40.0),
                  SizedBox(height: 5.0),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 16.0,
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

              await deleteCurrentAvatar(authUser?.avatar?.publicId);

              setState(() => isDeleteButtonPress = false);
            },
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.delete, size: 40.0),
                  SizedBox(height: 5.0),
                  Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 16.0,
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
