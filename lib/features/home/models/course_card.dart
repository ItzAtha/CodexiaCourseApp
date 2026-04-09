import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

enum CardType { course, courseDetail }

enum CourseLevel { beginner, intermediate, expert, master }

class CourseCard {
  final CardType _type;
  final String? _title;
  final String _description;
  final String? _overview;
  final String _courseImage;
  final String _courseRoutePath;
  final CourseLevel? _courseLevel;
  final List<CourseLevel> _availableLevels;
  final bool? _isMaintainable;

  String? get title => _title;

  CourseCard({
    required CardType type,
    String? title,
    required String description,
    String? overview,
    required String courseImage,
    required String courseRoutePath,
    CourseLevel? courseLevel,
    List<CourseLevel> availableLevels = const [
      CourseLevel.beginner,
      CourseLevel.intermediate,
      CourseLevel.expert,
    ],
    bool? isMaintainable,
  }) : _availableLevels = availableLevels,
       _isMaintainable = isMaintainable,
       _courseLevel = courseLevel,
       _courseRoutePath = courseRoutePath,
       _courseImage = courseImage,
       _overview = overview,
       _description = description,
       _title = title,
       _type = type {
    assert(
      type == CardType.course || (type == CardType.courseDetail && courseLevel != null),
      "Course level must be set for course detail card",
    );
  }

  Widget create(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      child: switch (_type) {
        CardType.course => ExpansionTile(
          title: Text(
            _title!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.labelSmall?.color,
            ),
          ),
          subtitle: Text(
            _description,
            style: TextStyle(fontSize: 14.0, color: Theme.of(context).textTheme.labelSmall?.color),
          ),
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset("assets/icons/$_courseImage"),
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          expansionAnimationStyle: AnimationStyle(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
          children: <Widget>[
            Divider(thickness: 1.5, height: 2.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Course Overview",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _overview!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Available Levels",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.spaceAround,
                    children: <Widget>[for (var level in _availableLevels) _getLevelBadge(level)],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_isMaintainable ?? false) {
                        Toastification().show(
                          title: Text("Coming Soon"),
                          description: Text("This course is under development. Stay tuned!"),
                          type: ToastificationType.info,
                          style: ToastificationStyle.flat,
                          alignment: Alignment.topCenter,
                          autoCloseDuration: Duration(seconds: 3),
                          animationDuration: Duration(milliseconds: 500),
                        );
                        return;
                      }

                      context.pushNamed(_courseRoutePath);
                    },
                    child: Text(
                      "See Details",
                      style: TextStyle(fontSize: 14.0, color: Color(0xFFF5F6FA)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        CardType.courseDetail => Column(
          children: <Widget>[
            SizedBox(
              height: 120.0,
              child: Stack(
                children: [
                  Positioned(
                    top: -40.0,
                    left: 0,
                    right: 0,
                    child: Image.asset("assets/images/$_courseImage"),
                  ),

                  Positioned(right: 10.0, top: 10.0, child: _getLevelBadge(_courseLevel!)),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "What you'll learn",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                  Divider(thickness: 1.0, height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(_courseRoutePath);
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(fontSize: 14.0, color: Color(0xFFF5F6FA)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      },
    );
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
}
