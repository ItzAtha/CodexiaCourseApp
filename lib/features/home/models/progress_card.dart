import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProgressCard {
  final String _title;
  final String _startDate;
  final CourseLevel _level;
  final double _progress;
  final String _courseImage;

  ProgressCard({
    required String title,
    required String startDate,
    required CourseLevel level,
    required double progress,
    required String courseImage,
  }) : _courseImage = courseImage,
       _progress = progress,
       _level = level,
       _startDate = startDate,
       _title = title;

  Widget create(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Skeleton.unite(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.calendar_today, size: 16.0, color: Color(0xFF0984E3)),
                      const SizedBox(width: 5.0),
                      Text(
                        _startDate,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Skeleton.leaf(child: _getLevelBadge(_level)),
              ],
            ),
            Divider(thickness: 1.0, color: Colors.grey.shade300, height: 20.0),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: Svg('assets/icons/$_courseImage'),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    _title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Progress", style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600)),
                const SizedBox(width: 10.0),
                Skeleton.leaf(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      "${(_progress * 100).toInt()}% Completed",
                      style: const TextStyle(fontSize: 12.0, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Color(0x6600CEC9),
              color: Color(0xFF00CEC9),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ],
        ),
      ),
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
