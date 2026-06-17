# Firebase Authentication Rules
-keep class com.google.firebase.auth.** { *; }
-dontwarn com.google.firebase.auth.**

# Google Tink Cryptography Rules
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Android WebKit/WebView Rules
-keep class android.webkit.** { *; }
-dontwarn android.webkit.**

# Google Play Services Rules
-keep class com.google.android.gms.auth.** { *; }
-dontwarn com.google.android.gms.auth.**