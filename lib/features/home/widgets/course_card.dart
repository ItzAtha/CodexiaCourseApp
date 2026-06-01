import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../shared/enums/course_level.dart';

class CourseCard {
  final String _id;
  final String _title;
  final String _description;
  final double _rating;
  final double _popular;
  final List<CourseLevel> _levels;
  final DateTime _createdAt;
  final bool _isActive;

  final ValueNotifier<bool> _isCardOpened = ValueNotifier<bool>(false);

  CourseCard(
    String id,
    String title,
    String description,
    double rating,
    double popular,
    List<CourseLevel> levels,
    DateTime createdAt,
    bool isActive,
  ) : _id = id,
      _title = title,
      _description = description,
      _rating = rating,
      _popular = popular,
      _levels = levels,
      _createdAt = createdAt,
      _isActive = isActive;

  Widget create(BuildContext context) {
    int fullStars = _rating.floor();
    bool hasHalfStar = (_rating - fullStars) >= 0.5; // Simple rounding threshold
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          if (_isNewestCourse)
            Container(
              color: const Color(0x9900CEC9),
              height: 30.0,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "New Course!",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ExpansionTile(
            title: Text(
              _title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Tooltip(
                  message: 'Rating',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        fullStars,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 16.0),
                      ),
                      if (hasHalfStar) const Icon(Icons.star_half, color: Colors.amber, size: 16.0),
                      ...List.generate(
                        emptyStars,
                        (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16.0),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        _rating.toStringAsFixed(_rating % 1 == 0 ? 0 : 1),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Tooltip(
                  message: 'Popularity',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, size: 16.0, color: Colors.redAccent),
                      const SizedBox(width: 6.0),
                      Text(
                        _formatPopular(_popular),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              backgroundImage: Svg('assets/icons/${_title.split(' ')[0].toLowerCase()}.svg'),
            ),
            trailing: ValueListenableBuilder<bool>(
              valueListenable: _isCardOpened,
              builder: (context, isOpened, child) {
                return AnimatedRotation(
                  turns: isOpened ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.0,
                    color: Theme.of(context).iconTheme.color,
                  ),
                );
              },
            ),
            shape: const Border(),
            collapsedShape: const Border(),
            expansionAnimationStyle: const AnimationStyle(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            onExpansionChanged: (value) {
              _isCardOpened.value = value;
            },
            children: <Widget>[
              const Divider(thickness: 1.5, height: 2.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Course Description",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(
                          context,
                        ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Available Levels",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      alignment: WrapAlignment.center,
                      children: <Widget>[for (var level in _levels) _getLevelBadge(level)],
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (!_isActive) {
                          Toastification().show(
                            title: const Text("Coming Soon"),
                            description: const Text(
                              "This course is under development. Stay tuned!",
                            ),
                            type: ToastificationType.info,
                            style: ToastificationStyle.flat,
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 3),
                            animationDuration: const Duration(milliseconds: 500),
                          );
                          return;
                        }

                        context.pushNamed(
                          '${_title.split(' ')[0].toLowerCase()}-course',
                          pathParameters: {'courseId': _id},
                        );
                      },
                      child: const Text(
                        "Start Course",
                        style: TextStyle(fontSize: 14.0, color: Color(0xFFF5F6FA)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPopular(double p) {
    if (p >= 1000000) {
      return '${(p / 1000000).toStringAsFixed((p / 1000000) % 1 == 0 ? 0 : 1)}M';
    }
    if (p >= 1000) {
      return '${(p / 1000).toStringAsFixed((p / 1000) % 1 == 0 ? 0 : 1)}k';
    }
    if (p % 1 == 0) {
      return p.toInt().toString();
    }
    return p.toStringAsFixed(1);
  }

  Widget _getLevelBadge(CourseLevel level) {
    String text;
    MaterialColor color;

    switch (level) {
      case CourseLevel.beginner:
        text = "Beginner Level";
        color = Colors.green;
        break;
      case CourseLevel.intermediate:
        text = "Intermediate Level";
        color = Colors.orange;
        break;
      case CourseLevel.expert:
        text = "Expert Level";
        color = Colors.red;
        break;
      case CourseLevel.master:
        text = "Master Level";
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.shade100, color.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(text, style: TextStyle(fontSize: 12.0, color: color.shade900)),
    );
  }

  String get title => _title;

  double get rating => _rating;

  double get popular => _popular;

  DateTime get createdAt => _createdAt;

  bool get _isNewestCourse {
    Duration diff = DateTime.now().difference(_createdAt);
    if (diff.inDays < 2) {
      return true;
    }
    return false;
  }
}
