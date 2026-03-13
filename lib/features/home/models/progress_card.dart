import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum Level { beginner, intermediate, expert }

class ProgressCard {
  final String _title;
  final String _startDate;
  final Level _level;
  final double _progress;
  final String _courseImage;

  ProgressCard({
    required String title,
    required String startDate,
    required Level level,
    required double progress,
    required String courseImage,
  }) : _courseImage = courseImage,
       _progress = progress,
       _level = level,
       _startDate = startDate,
       _title = title;

  Widget create() {
    return Card(
      elevation: 8.0,
      color: Color(0xFFFCFBFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_today,
                      size: 16.0,
                      color: Color(0xFF0984E3),
                    ),
                    const SizedBox(width: 5.0),
                    Text(_startDate, style: TextStyle(fontSize: 14.0)),
                  ],
                ),
                _getLevelBadge(_level),
              ],
            ),
            Divider(thickness: 1.0, color: Colors.grey.shade300, height: 20.0),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset("assets/icons/$_courseImage"),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    _title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Progress",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
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

  Widget _getLevelBadge(Level level) {
    String text;
    MaterialColor color;

    switch (level) {
      case Level.beginner:
        text = "Beginner Level";
        color = Colors.green;
        break;
      case Level.intermediate:
        text = "Intermediate Level";
        color = Colors.orange;
        break;
      case Level.expert:
        text = "Expert Level";
        color = Colors.red;
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
      child: Text(
        text,
        style: TextStyle(fontSize: 12.0, color: color.shade900),
      ),
    );
  }
}
