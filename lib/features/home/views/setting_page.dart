import 'package:codexia_course_learning/core/utils/logger.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../services/cloudinary_services.dart';
import '../../../shared/models/user_avatar.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingPageState();
}

enum ThemeOptions { auto, light, dark }

enum LanguageOptions { en, id }

class _SettingPageState extends ConsumerState<SettingPage> {
  bool isFingerprintEnable = false;
  bool isThemeOptionOpened = false;
  bool isLanguageOptionOpened = false;

  ThemeOptions? themeOptions = ThemeOptions.auto;
  LanguageOptions? languageOptions = LanguageOptions.en;

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
        (String?, String?)? userAvatar = await CloudinaryServices().uploadImage(image.path);

        if (userAvatar != null) {
          DebugLogger(message: "Public Id: ${userAvatar.$1}", level: LogLevel.info).log();
          DebugLogger(message: "URL: ${userAvatar.$2}", level: LogLevel.info).log();

          await deleteCurrentAvatar(publicId);
          UserAvatar avatar = UserAvatar(publicId: userAvatar.$1!, avatarPath: userAvatar.$2!);
          ref.read(authUserProvider.notifier).updateAvatar(avatar);
        }
      }
    } catch (error, stackTrace) {
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
      DebugLogger(message: "Avatar deleted successfully", level: LogLevel.info).log();
    } else {
      DebugLogger(message: "Failed to delete avatar", level: LogLevel.info).log();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
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
                                    elevation: 8.0,
                                    showDragHandle: true,
                                    backgroundColor: Color(0xFFF5F6FA),
                                    builder: (context) {
                                      return Consumer(
                                        builder: (context, ref, child) {
                                          final authUserState = ref.watch(authUserProvider);
                                          AuthUser? authUser = authUserState.value;

                                          return SizedBox(
                                            height: 130.0,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () => selectAvatarImage(
                                                    ImageSource.camera,
                                                    publicId: authUser?.avatar?.publicId,
                                                  ),
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
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
                                                          style: TextStyle(fontSize: 16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => selectAvatarImage(
                                                    ImageSource.gallery,
                                                    publicId: authUser?.avatar?.publicId,
                                                  ),
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
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
                                                          style: TextStyle(fontSize: 16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => deleteCurrentAvatar(
                                                    authUser?.avatar?.publicId,
                                                  ),
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
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
                                                          style: TextStyle(fontSize: 16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
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
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text(authUser?.email ?? "guest@gmail.com", style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              OutlinedButton(
                onPressed: () {
                  DebugLogger(message: "Edit Profile", level: LogLevel.debug).log();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: Size(180.0, 40.0),
                ),
                child: Text("Edit Profile", style: TextStyle(color: Colors.black, fontSize: 16.0)),
              ),
              SizedBox(height: 40.0),
              Card(
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "General",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(thickness: 1.2, height: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          DebugLogger(message: "Change Theme", level: LogLevel.debug).log();
                          setState(() => isThemeOptionOpened = value);
                        },
                        leading: Icon(Icons.color_lens),
                        title: Text("Change Theme"),
                        trailing: AnimatedRotation(
                          turns: isThemeOptionOpened ? 0.25 : 0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                        tilePadding: EdgeInsets.only(left: 10.0, right: 10.0),
                        iconColor: Colors.grey.shade800,
                        expansionAnimationStyle: AnimationStyle(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 500),
                        ),
                        children: <Widget>[
                          RadioGroup<ThemeOptions>(
                            groupValue: themeOptions,
                            onChanged: (value) {
                              setState(() => themeOptions = value);
                              DebugLogger(
                                message: "Theme Options: $themeOptions",
                                level: LogLevel.debug,
                              ).log();
                            },
                            child: Column(
                              children: <Widget>[
                                RadioListTile<ThemeOptions>(
                                  title: Text("Auto"),
                                  value: ThemeOptions.auto,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<ThemeOptions>(
                                  title: Text("Light"),
                                  value: ThemeOptions.light,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<ThemeOptions>(
                                  title: Text("Dark"),
                                  value: ThemeOptions.dark,
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
                        leading: Icon(Icons.notifications),
                        title: Text("Notifications"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Accessibility", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.accessibility),
                        title: Text("Accessibility"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          DebugLogger(message: "Change Language", level: LogLevel.debug).log();
                          setState(() => isLanguageOptionOpened = value);
                        },
                        leading: Icon(Icons.language),
                        title: Text("Change Language"),
                        trailing: AnimatedRotation(
                          turns: isLanguageOptionOpened ? 0.25 : 0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Icon(Icons.arrow_forward_ios),
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
                                  title: Text("English"),
                                  value: LanguageOptions.en,
                                  activeColor: Color(0xFF00CEC9),
                                ),
                                RadioListTile<LanguageOptions>(
                                  title: Text("Indonesia"),
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
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Security",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(thickness: 1.2, height: 20.0, color: Colors.black),
                          ),
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
                        leading: Icon(Icons.fingerprint),
                        title: Text("Enable Fingerprint"),
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
                        leading: Icon(Icons.security),
                        title: Text("Enable 2FA"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Device Management", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.devices),
                        title: Text("Device Management"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "App Permissions", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.perm_device_info),
                        title: Text("App Permissions"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Help Center",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(thickness: 1.2, height: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "FAQ", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.question_answer),
                        title: Text("FAQ"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "About Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.info),
                        title: Text("About Us"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Rate Us", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.star),
                        title: Text("Rate Us"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Privacy Policy", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.policy),
                        title: Text("Privacy Policy"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Term of Service", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.privacy_tip),
                        title: Text("Term of Service"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          DebugLogger(message: "Contact Support", level: LogLevel.debug).log();
                        },
                        leading: Icon(Icons.contact_support),
                        title: Text("Contact Support"),
                        trailing: Icon(Icons.arrow_forward_ios),
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
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Danger Zone",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(thickness: 1.2, height: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          DebugLogger(message: "Reset Course", level: LogLevel.debug).log();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
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
                        onPressed: () {
                          DebugLogger(message: "Logout Account", level: LogLevel.debug).log();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
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
