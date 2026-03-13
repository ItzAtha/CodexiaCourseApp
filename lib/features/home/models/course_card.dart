import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CourseCard {
  final String _title;
  final String _description;
  final String _overview;
  final String _courseImage;

  CourseCard({
    required String title,
    required String description,
    required String overview,
    required String courseImage,
  }) : _courseImage = courseImage, _overview = overview, _description = description, _title = title;

  Widget create() {
    return Card(
      elevation: 4.0,
      color: Color(0xFFFCFBFB),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _description,
        ),
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset("assets/icons/$_courseImage"),
        ),
        expansionAnimationStyle: AnimationStyle(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.5,
            color: Colors.grey.shade300,
            height: 2.0,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Course Overview",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  _overview,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Available Levels",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade100,
                            Colors.green.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Text(
                        "Beginner",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Text(
                        "Intermediate",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade100,
                            Colors.red.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Text(
                        "Expert",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle enroll action
                    print("Enroll in ${_title.split(" ").first} Development");
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStatePropertyAll(
                      Color(0xFF0984E3),
                    ),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size(150.0, 36.0),
                    ),
                  ),
                  child: Text("See Details", style: TextStyle(color: Color(0xFFF5F6FA), fontSize: 14.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}