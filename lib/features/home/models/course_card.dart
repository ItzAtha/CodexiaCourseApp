import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animations/animations.dart';

enum CardType { course, courseDetail }

enum CourseLevel { beginner, intermediate, expert }

class CourseCard {
  final CardType _type;
  final String? _title;
  final String _description;
  final String? _overview;
  final String _courseImage;
  final Widget _courseMenu;
  final CourseLevel? _courseLevel;

  String? get title => _title;

  CourseCard({
    required CardType type,
    String? title,
    required String description,
    String? overview,
    required String courseImage,
    required Widget courseMenu,
    CourseLevel? courseLevel,
  }) : _courseLevel = courseLevel,
       _courseMenu = courseMenu,
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

  Widget create() {
    return OpenContainer(
      tappable: false,
      openElevation: 4.0,
      closedElevation: 0.0,
      openColor: Color(0xFFF5F6FA),
      closedColor: Color(0xFFF5F6FA),
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      transitionDuration: Duration(milliseconds: 800),
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (context, openAction) {
        return Card(
          elevation: 4.0,
          color: Color(0xFFFCFBFB),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
          child: switch (_type) {
            CardType.course => ExpansionTile(
              title: Text(_title!, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              subtitle: Text(_description),
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
                Divider(thickness: 1.5, color: Colors.grey.shade300, height: 2.0),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Course Overview",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _overview!,
                        style: TextStyle(fontSize: 14.0, color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Available Levels",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade100, Colors.green.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "Beginner",
                              style: TextStyle(fontSize: 12.0, color: Colors.green.shade900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade100, Colors.orange.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "Intermediate",
                              style: TextStyle(fontSize: 12.0, color: Colors.orange.shade900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade100, Colors.red.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "Expert",
                              style: TextStyle(fontSize: 12.0, color: Colors.red.shade900),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: openAction,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xFF0984E3)),
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 4.0)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                          fixedSize: WidgetStatePropertyAll(Size(150.0, 36.0)),
                        ),
                        child: Text(
                          "See Details",
                          style: TextStyle(color: Color(0xFFF5F6FA), fontSize: 14.0),
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
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.0),
                      Text(_description, textAlign: TextAlign.justify),
                      Divider(thickness: 1.0, color: Colors.grey.shade400, height: 20.0),
                      ElevatedButton(
                        onPressed: openAction,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xFF0984E3)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        child: Text(
                          "Get Started",
                          style: TextStyle(color: Color(0xFFF5F6FA), fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          },
        );
      },
      openBuilder: (context, closeAction) => _courseMenu,
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
