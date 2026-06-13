import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constants.dart' show AppSizes, AppColors;
import '../../../shared/models/course/course_module.dart';

class CourseModuleCard extends StatelessWidget {
  final String _courseId;
  final CourseLevel _levelId;
  final CourseModule _module;

  final double _progress;
  final bool? _isLocked;

  AnimationController? _animationController;

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

  bool get _isModuleLocked {
    return _isLocked ?? false;
  }

  bool get _isModuleCompleted {
    return _progress == 1.0;
  }

  Color _getColorState() {
    if (_isLocked ?? false) {
      return Colors.grey;
    } else if (_isModuleCompleted) {
      return AppColors.secondary;
    } else {
      return AppColors.primary;
    }
  }

  String _formatDuration(Duration d) {
    int hours = d.inHours;
    int minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Widget _getIconState() {
    if (_isModuleLocked) {
      return const FaIcon(FontAwesomeIcons.lock, color: Colors.grey);
    } else if (_isModuleCompleted) {
      return const FaIcon(FontAwesomeIcons.circleCheck, color: AppColors.secondary);
    } else {
      return Text(
        "${_module.order}",
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (_isLocked ?? false) {
          _animationController?.forward(from: 0.0);
        } else {
          context.pushNamed(
            'course-module',
            pathParameters: {
              'courseId': _courseId,
              'levelId': _levelId.name.toLowerCase(),
              'moduleId': _module.moduleId,
            },
            extra: _module.lessons,
          );
        }

        print("Path To: course/$_courseId/${_levelId.name.toLowerCase()}/${_module.moduleId}");
      },
      child:
          Card(
                elevation: 1.5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                                color: _getColorState(),
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
                                color: _getColorState().withValues(alpha: 0.25),
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: _getIconState(),
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
                                            _module.title,
                                            style: TextStyle(
                                              fontSize: AppSizes.mlTextSize,
                                              fontWeight: FontWeight.bold,
                                              color: theme.textTheme.labelSmall?.color,
                                            ),
                                          ),
                                        ),
                                        if (!_isModuleLocked)
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
                                              "+${_module.expAmount} XP",
                                              style: const TextStyle(
                                                fontSize: AppSizes.smTextSize,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      _module.description,
                                      style: TextStyle(
                                        fontSize: AppSizes.smTextSize,
                                        color: theme.textTheme.labelSmall?.color?.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                    if (!_isModuleLocked) const SizedBox(height: 8.0),
                                    if (!_isModuleLocked)
                                      LinearProgressIndicator(
                                        value: _progress,
                                        backgroundColor: _isModuleCompleted
                                            ? AppColors.secondary.withValues(alpha: 0.3)
                                            : AppColors.primary.withValues(alpha: 0.3),
                                        color: _isModuleCompleted
                                            ? AppColors.secondary
                                            : AppColors.primary,
                                        minHeight: 6.0,
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                      ),
                                    const SizedBox(height: 6.0),
                                    Row(
                                      children: <Widget>[
                                        const FaIcon(FontAwesomeIcons.bookOpen, size: 12.0),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          "${_module.lessons.length} Lessons",
                                          style: TextStyle(
                                            fontSize: AppSizes.sTextSize,
                                            color: theme.textTheme.labelSmall?.color?.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const FaIcon(FontAwesomeIcons.clock, size: 12.0),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          _formatDuration(_module.duration),
                                          style: TextStyle(
                                            fontSize: AppSizes.sTextSize,
                                            color: theme.textTheme.labelSmall?.color?.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        if (!_isModuleLocked)
                                          _isModuleCompleted
                                              ? const Text(
                                                  "Completed",
                                                  style: TextStyle(
                                                    fontSize: AppSizes.sTextSize,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.secondary,
                                                  ),
                                                )
                                              : Text(
                                                  "${NumberFormat.percentPattern().format(_progress)} Done",
                                                  style: const TextStyle(
                                                    fontSize: AppSizes.sTextSize,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary,
                                                  ),
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
                        width: 50,
                        height: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.0,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(autoPlay: false, onInit: (controller) => _animationController = controller)
              .shakeX(hz: 4, duration: 500.ms),
    );
  }
}
