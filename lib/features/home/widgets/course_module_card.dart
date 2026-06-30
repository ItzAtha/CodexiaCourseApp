import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constants.dart' show AppSizes, AppColors;
import '../../../shared/models/course/course_module.dart';

class CourseModuleCard extends StatefulWidget {
  final String _courseId;
  final CourseLevel _levelId;
  final CourseModule _module;

  final double _progress;
  final bool? _isLocked;

  CourseModuleCard(
    this._courseId,
    this._levelId,
    this._module,
    this._progress, {
    super.key,
    bool? isLocked = false,
  }) : _isLocked = isLocked {
    assert(_progress >= 0.0 && _progress <= 1.0, "Progress range must be in 0.0 until 1.0!");
  }

  @override
  State<CourseModuleCard> createState() => _CourseModuleCardState();
}

class _CourseModuleCardState extends State<CourseModuleCard> {
  AnimationController? animationController;

  bool get isModuleLocked {
    return widget._isLocked ?? false;
  }

  bool get isModuleCompleted {
    return widget._progress == 1.0;
  }

  Color getColorState() {
    if (widget._isLocked ?? false) {
      return Colors.grey;
    } else if (isModuleCompleted) {
      return AppColors.secondary;
    } else {
      return AppColors.primary;
    }
  }

  String formatDuration(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Widget getIconState() {
    if (isModuleLocked) {
      return const FaIcon(FontAwesomeIcons.lock, color: Colors.grey);
    } else if (isModuleCompleted) {
      return const FaIcon(FontAwesomeIcons.circleCheck, color: AppColors.secondary);
    } else {
      return Text(
        "${widget._module.order}",
        style: const TextStyle(
          fontSize: AppSizes.xlTextSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget._isLocked ?? false) {
          if (animationController?.isAnimating ?? false) return;
          animationController?.forward(from: 0.0);
        } else {
          context.pushNamed(
            'course-module',
            pathParameters: {
              'courseId': widget._courseId,
              'levelId': widget._levelId.name.toLowerCase(),
              'moduleId': widget._module.moduleId,
            },
            extra: widget._module.lessons,
          );
        }

        debugPrint(
          "Path To: course/${widget._courseId}/${widget._levelId.name.toLowerCase()}/${widget._module.moduleId}",
        );
      },
      child:
          Card(
                elevation: 1.5,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 8.0,
                              decoration: BoxDecoration(
                                color: getColorState(),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Container(
                              width: 54.0,
                              height: 54.0,
                              padding: const EdgeInsets.all(AppSizes.p12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: getColorState().withValues(alpha: 0.25),
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: getIconState(),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            widget._module.title,
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                        ),
                                        if (!isModuleLocked)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSizes.p8,
                                              vertical: AppSizes.p8 / 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary.withValues(alpha: 0.2),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              "+${widget._module.expAmount} XP",
                                              style: Theme.of(context).textTheme.labelMedium
                                                  ?.copyWith(color: AppColors.secondary),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      widget._module.description,
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    if (!isModuleLocked) const SizedBox(height: 8.0),
                                    if (!isModuleLocked)
                                      TweenAnimationBuilder<double>(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                        tween: Tween<double>(begin: 0.0, end: widget._progress),
                                        builder: (context, value, child) {
                                          return LinearProgressIndicator(
                                            value: value,
                                            backgroundColor: isModuleCompleted
                                                ? AppColors.secondary.withValues(alpha: 0.3)
                                                : AppColors.primary.withValues(alpha: 0.3),
                                            color: isModuleCompleted
                                                ? AppColors.secondary
                                                : AppColors.primary,
                                            minHeight: 6.0,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          );
                                        },
                                      ),
                                    const SizedBox(height: 6.0),
                                    Row(
                                      children: <Widget>[
                                        const FaIcon(FontAwesomeIcons.bookOpen, size: 12.0),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          "${widget._module.lessons.length} Lessons",
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const FaIcon(FontAwesomeIcons.clock, size: 12.0),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          formatDuration(widget._module.duration),
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        if (!isModuleLocked)
                                          isModuleCompleted
                                              ? Text(
                                                  "Completed",
                                                  style: Theme.of(context).textTheme.labelSmall
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.secondary,
                                                      ),
                                                )
                                              : TweenAnimationBuilder<double>(
                                                  duration: const Duration(seconds: 1),
                                                  curve: Curves.easeInOut,
                                                  tween: Tween<double>(
                                                    begin: 0.0,
                                                    end: widget._progress,
                                                  ),
                                                  builder: (context, value, child) {
                                                    return Text(
                                                      "${NumberFormat.percentPattern().format(value)} Done",
                                                      style: Theme.of(context).textTheme.labelSmall
                                                          ?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.primary,
                                                          ),
                                                    );
                                                  },
                                                ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: const Icon(Icons.arrow_forward_ios, size: 24.0),
                      ),
                    ],
                  ),
                ),
              )
              .animate(autoPlay: false, onInit: (controller) => animationController = controller)
              .shakeX(hz: 4, duration: 500.ms),
    );
  }
}
