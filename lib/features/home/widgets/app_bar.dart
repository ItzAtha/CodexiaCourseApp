import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/app_constants.dart' show AppColors, AppSizes;
import '../../../core/utils/logger.dart';
import '../../../shared/models/auth_user.dart';
import '../../../shared/providers/auth_user_notifier.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    final UniqueKey skeletonizerKey = UniqueKey();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Skeletonizer(
              key: skeletonizerKey,
              enabled: authUserState.isLoading,
              enableSwitchAnimation: true,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 45.0,
                    height: 45.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      child: CachedNetworkImage(
                        imageUrl:
                            authUser?.avatar ??
                            "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Container(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Skeleton.keep(
                        key: skeletonizerKey,
                        child: Text(
                          "Welcome Back,",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: Colors.white),
                        ),
                      ),
                      Text(
                        authUser?.displayName ?? authUser?.username ?? "Guest",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  // Handle notification tap
                  DebugLogger(message: "Notification tapped", level: LogLevel.debug).log();
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.p8 / 2),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.p8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCFBFB),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        const Icon(Icons.notifications, size: 20.0, color: Colors.blue),
                        Positioned(
                          top: 1.0,
                          right: 2.0,
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(74.0);
}
