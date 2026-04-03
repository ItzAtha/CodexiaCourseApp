import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              SizedBox(
                height: mediaQuery.orientation == Orientation.portrait
                    ? 80.0
                    : 10.0,
              ),
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
                          CircleAvatar(
                            radius: 55.0,
                            backgroundImage: NetworkImage(
                              authUser?.avatarPath ??
                                  "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Skeleton.ignore(
                              child: FloatingActionButton.small(
                                onPressed: () => print("Edit Profile Image"),
                                shape: CircleBorder(),
                                backgroundColor: Color(0xFF00CEC9),
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFFF5F6FA),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      authUser?.displayName ?? authUser?.username ?? "Guest",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      authUser?.email ?? "guest@gmail.com",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              OutlinedButton(
                onPressed: () {
                  print("Edit Profile");
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(180.0, 40.0),
                ),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              SizedBox(height: 40.0),
              Card(
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 14.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "General",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(
                              thickness: 1.2,
                              height: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          print("Change Theme");
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
                              print("Theme Options: $themeOptions");
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
                          print("Notifications");
                        },
                        leading: Icon(Icons.notifications),
                        title: Text("Notifications"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Accessibility");
                        },
                        leading: Icon(Icons.accessibility),
                        title: Text("Accessibility"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          print("Change Language");
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
                              print("Theme Options: $languageOptions");
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 14.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Security",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(
                              thickness: 1.2,
                              height: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          print("Enable Fingerprint");

                          setState(
                            () => isFingerprintEnable = !isFingerprintEnable,
                          );
                          print("Is Fingerprint Enable? $isFingerprintEnable");
                        },
                        leading: Icon(Icons.fingerprint),
                        title: Text("Enable Fingerprint"),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isFingerprintEnable,
                            onChanged: (value) {
                              setState(() => isFingerprintEnable = value);
                              print(
                                "Is Fingerprint Enable? $isFingerprintEnable",
                              );
                            },
                            activeTrackColor: Color(0xFF00CEC9),
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 10.0, right: 5.0),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Enable 2FA");
                        },
                        leading: Icon(Icons.security),
                        title: Text("Enable 2FA"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Device Management");
                        },
                        leading: Icon(Icons.devices),
                        title: Text("Device Management"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("App Permissions");
                        },
                        leading: Icon(Icons.perm_device_info),
                        title: Text("App Permissions"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 14.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Help Center",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(
                              thickness: 1.2,
                              height: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          print("FAQ");
                        },
                        leading: Icon(Icons.question_answer),
                        title: Text("FAQ"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("About Us");
                        },
                        leading: Icon(Icons.info),
                        title: Text("About Us"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Rate Us");
                        },
                        leading: Icon(Icons.star),
                        title: Text("Rate Us"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Privacy Policy");
                        },
                        leading: Icon(Icons.policy),
                        title: Text("Privacy Policy"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Term of Service");
                        },
                        leading: Icon(Icons.privacy_tip),
                        title: Text("Term of Service"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      Divider(thickness: 1.0, height: 1.0),
                      ListTile(
                        onTap: () {
                          print("Contact Support");
                        },
                        leading: Icon(Icons.contact_support),
                        title: Text("Contact Support"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        contentPadding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                color: Color(0xFFFCFBFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 14.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Danger Zone",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(
                              thickness: 1.2,
                              height: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          print("Reset Course");
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Reset Course",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.restart_alt, color: Colors.redAccent),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () {
                          print("Logout Account");
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Logout Account",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.logout, color: Colors.redAccent),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      OutlinedButton(
                        onPressed: () {
                          print("Delete Account");
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: Size(double.infinity, 42.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Delete Account",
                              style: TextStyle(color: Colors.redAccent),
                            ),
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
