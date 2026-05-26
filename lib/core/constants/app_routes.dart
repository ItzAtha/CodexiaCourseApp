class AppRoutes {
  AppRoutes._();

  // ============[ Authentication route ]============
  static const ({String name, String path}) authRoute = (path: '/auth', name: "authentication");
  static const ({String name, String path}) loginRoute = (path: 'login', name: "login");
  static const ({String name, String path}) registerRoute = (path: 'register', name: "register");
  static const ({String name, String path}) resetPassRoute = (
    path: 'reset-password',
    name: "reset-password",
  );

  // ============[ Navigation route ]============
  static const ({String name, String path}) homeRoute = (path: '/home', name: "home");
  static const ({String name, String path}) courseRoute = (path: '/course', name: "course");
  static const ({String name, String path}) communityRoute = (
    path: '/community',
    name: "community",
  );
  static const ({String name, String path}) settingsRoute = (path: '/settings', name: "settings");

  // ============[ Shortcut (FAB) route ]============
  static const ({String name, String path}) sandboxRoute = (path: '/sandbox', name: "sandbox");
  static const ({String name, String path}) chatBotRoute = (path: '/chat-bot', name: "chat-bot");
  static const ({String name, String path}) challengeRoute = (
    path: '/challenge',
    name: "challenge",
  );

  // ============[ Setting route ]============
  // General route
  static const ({String name, String path}) editProfileRoute = (
    path: '/edit-profile',
    name: "edit-profile",
  );
  static const ({String name, String path}) notificationRoute = (
    path: '/notifications',
    name: "notifications",
  );
  static const ({String name, String path}) accessibilityRoute = (
    path: '/accessibility',
    name: "accessibility",
  );

  // Security route
  static const ({String name, String path}) factorAuthRoute = (
    path: '/factor-auth',
    name: "factor-auth",
  );
  static const ({String name, String path}) fingerprintRoute = (
    path: '/fingerprint',
    name: "fingerprint",
  );
  static const ({String name, String path}) manageDeviceRoute = (
    path: '/manage-device',
    name: "manage-device",
  );
  static const ({String name, String path}) appPermissionRoute = (
    path: '/app-permissions',
    name: "app-permissions",
  );

  // Help Center route
  static const ({String name, String path}) faqRoute = (path: '/faq', name: "faq");
  static const ({String name, String path}) aboutAppRoute = (path: '/about-app', name: "about-app");
  static const ({String name, String path}) contactSupportRoute = (
    path: '/contact-support',
    name: "contact-support",
  );

  // ============[ Legality route ]============
  static const ({String name, String path}) tosRoute = (path: '/term-of-service', name: "tos");
  static const ({String name, String path}) privacyRoute = (
    path: '/privacy-policy',
    name: "privacy-policy",
  );
}
