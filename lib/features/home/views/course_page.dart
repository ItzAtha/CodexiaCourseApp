import 'package:codexia_course_learning/features/home/models/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<StatefulWidget> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<bool> isSelected = [false, false, false];

  final courseCardList = {
    "Programming Foundations": [
      CourseCard(
          title: "Java Development",
          description: "Learn Java programming and its applications in various domains.",
          overview: "In this course, you will learn the fundamentals of Java programming language, including syntax, object-oriented programming concepts, and how to build applications using Java. Whether you're a beginner or looking to enhance your Java skills, this course will provide you with the knowledge and practical experience needed to succeed in Java development.",
        courseImage: "java.svg"
      ).create(),
      CourseCard(
          title: "Python Development",
          description: "Learn Python programming and its applications in various domains.",
          overview: "In this course, you will learn the fundamentals of Python programming language, including syntax, data structures, and how to build applications using Python. Whether you're a beginner or looking to enhance your Python skills, this course will provide you with the knowledge and practical experience needed to succeed in Python development.",
          courseImage: "python.svg"
      ).create(),
      CourseCard(
          title: "Web Development",
          description: "Learn how to build modern and responsive websites using HTML, CSS, and JavaScript.",
          overview: "In this course, you will learn the fundamentals of web development, including HTML for structuring web pages, CSS for styling, and JavaScript for adding interactivity. Whether you're a beginner or looking to enhance your web development skills, this course will provide you with the knowledge and practical experience needed to build modern and responsive websites.",
          courseImage: "web.svg"
      ).create(),
      CourseCard(
          title: "PHP Development",
          description: "Learn PHP programming and its applications in web development.",
          overview: "In this course, you will learn the fundamentals of PHP programming language, including syntax, data structures, and how to build web applications using PHP. Whether you're a beginner or looking to enhance your PHP skills, this course will provide you with the knowledge and practical experience needed to succeed in PHP development.",
          courseImage: "php.svg"
      ).create(),
      CourseCard(
          title: "C Family Development",
          description: "Learn C, C++, and C# programming languages and their applications in various domains.",
          overview: "In this course, you will learn the fundamentals of C, C++, and C# programming languages, including syntax, data structures, and how to build applications using these languages. Whether you're a beginner or looking to enhance your skills in C, C++, or C#, this course will provide you with the knowledge and practical experience needed to succeed in development using these languages.",
          courseImage: "c.svg"
      ).create(),
      CourseCard(
        title: "Dart Development",
        description: "Learn Dart programming and its applications in Flutter development.",
        overview: "In this course, you will learn the fundamentals of Dart programming language, including syntax, data structures, and how to build applications using Dart. Whether you're a beginner or looking to enhance your Dart skills, this course will provide you with the knowledge and practical experience needed to succeed in Dart development, especially in the context of Flutter framework development.",
        courseImage: "dart.svg"
      ).create(),
      CourseCard(
          title: "Arduino Development",
          description: "Learn how to build interactive projects and prototypes using Arduino microcontroller platform.",
          overview: "In this course, you will learn the fundamentals of Arduino development, including programming the Arduino board, working with sensors and actuators, and building interactive projects. Whether you're a beginner or looking to enhance your skills in Arduino development, this course will provide you with the knowledge and practical experience needed to create innovative projects using the Arduino platform.",
          courseImage: "arduino.svg"
      ).create(),
    ],
    "Database Structures": [
      CourseCard(
        title: "SQL Database",
        description: "Learn how to design and manage relational databases using SQL.",
        overview: "In this course, you will learn the fundamentals of SQL databases, including database design, querying, and management using SQL. Whether you're a beginner or looking to enhance your SQL skills, this course will provide you with the knowledge and practical experience needed to succeed in SQL database development.",
        courseImage: "sql.svg"
      ).create(),
      CourseCard(
        title: "Prisma Database",
        description: "Learn how to design and manage databases using Prisma ORM.",
        overview: "In this course, you will learn the fundamentals of Prisma database development, including database design, querying, and management using Prisma ORM. Whether you're a beginner or looking to enhance your Prisma skills, this course will provide you with the knowledge and practical experience needed to succeed in Prisma database development.",
        courseImage: "prisma.svg"
      ).create(),
    ],
    "Framework Development": [
      CourseCard(
        title: "Spring Framework",
        description: "Learn how to build enterprise-level applications using the Spring Java framework.",
        overview: "In this course, you will learn the fundamentals of Spring framework development, including Java programming language, Spring architecture, dependency injection, and how to build enterprise-level applications using the Spring Java framework. Whether you're a beginner or looking to enhance your Spring skills, this course will provide you with the knowledge and practical experience needed to succeed in Spring framework development.",
        courseImage: "spring.svg"
      ).create(),
      CourseCard(
        title: "Django Framework",
        description: "Learn how to build secure and scalable web applications using the Django Python framework.",
        overview: "In this course, you will learn the fundamentals of Django framework development, including Python programming language, Django architecture, routing, database management, and how to build secure and scalable web applications using the Django Python framework. Whether you're a beginner or looking to enhance your Django skills, this course will provide you with the knowledge and practical experience needed to succeed in Django framework development.",
        courseImage: "django.svg"
      ).create(),
      CourseCard(
        title: "Laravel Framework",
        description: "Learn how to build robust and scalable web applications using the Laravel PHP framework.",
        overview: "In this course, you will learn the fundamentals of Laravel framework development, including PHP programming language, Laravel architecture, routing, database management, and how to build robust and scalable web applications using the Laravel PHP framework. Whether you're a beginner or looking to enhance your Laravel skills, this course will provide you with the knowledge and practical experience needed to succeed in Laravel framework development.",
        courseImage: "laravel.svg"
      ).create(),
      CourseCard(
        title: "React JS Library",
        description: "Learn how to build dynamic and interactive web applications using the React JS library.",
        overview: "In this course, you will learn the fundamentals of React JS development, including JSX syntax, component-based architecture, state management, and how to build dynamic and interactive web applications using the React JS library. Whether you're a beginner or looking to enhance your React JS skills, this course will provide you with the knowledge and practical experience needed to succeed in React JS development.",
        courseImage: "reactjs.svg"
      ).create(),
      CourseCard(
          title: "Next JS Framework",
          description: "Learn how to build server-rendered React applications using the Next JS framework.",
          overview: "In this course, you will learn the fundamentals of Next JS framework development, including JavaScript programming language, Next JS architecture, routing, server-side rendering, and how to build server-rendered React applications using the Next JS framework. Whether you're a beginner or looking to enhance your Next JS skills, this course will provide you with the knowledge and practical experience needed to succeed in Next JS framework development.",
          courseImage: "nextjs.svg"
      ).create(),
      CourseCard(
        title: "Express JS Framework",
        description: "Learn how to build fast and scalable web applications using the Express JS framework.",
        overview: "In this course, you will learn the fundamentals of Express JS development, including JavaScript programming language, Express architecture, routing, middleware, and how to build fast and scalable web applications using the Express JS framework. Whether you're a beginner or looking to enhance your Express JS skills, this course will provide you with the knowledge and practical experience needed to succeed in Express JS development.",
        courseImage: "express.svg"
      ).create(),
      CourseCard(
        title: "Flutter Framework",
        description: "Learn how to build beautiful and performant mobile apps using the Flutter framework.",
        overview: "In this course, you will learn the fundamentals of Flutter framework development, including Dart programming language, Flutter widgets, state management, and how to build cross-platform mobile applications using Flutter. Whether you're a beginner or looking to enhance your Flutter skills, this course will provide you with the knowledge and practical experience needed to succeed in Flutter framework development.",
        courseImage: "flutter.svg"
      ).create(),
      CourseCard(
        title: "Arduino with PlatformIO",
        description: "Learn how to build interactive projects and prototypes using Arduino with PlatformIO IDE.",
        overview: "In this course, you will learn the fundamentals of Arduino development using PlatformIO IDE, including programming the Arduino board, working with sensors and actuators, and building interactive projects. Whether you're a beginner or looking to enhance your skills in Arduino development with PlatformIO, this course will provide you with the knowledge and practical experience needed to create innovative projects using the Arduino platform with PlatformIO IDE.",
        courseImage: "platformio.svg"
      ).create(),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20.0),
              SizedBox(
                height: 45.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SearchBar(
                        leading: const Icon(Icons.search, size: 20.0),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        hintText: "Search for courses",
                        onChanged: (value) {
                          // Handle search input change
                          print("Search input: $value");
                        },
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    SizedBox(
                      width: 45.0,
                      height: 45.0,
                      child: Material(
                        elevation: 8.0,
                        color: Color(0xFFFCFBFB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle filter action
                            print("Filter button pressed");

                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F6FA),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              "Filter Courses",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 20.0),
                                            Text(
                                              "Sort by",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 0.8,
                                              color: Colors.grey.shade300,
                                              height: 10.0,
                                            ),
                                            SizedBox(height: 10.0),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    FilterChip(
                                                      label: Text(
                                                        "Popular",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      onSelected: (selected) {
                                                        setState(() {
                                                          isSelected[0] =
                                                              selected;

                                                          // Handle sort by popularity
                                                          print(
                                                            "Sort by Popular",
                                                          );
                                                        });
                                                      },
                                                      elevation: 4.0,
                                                      selected: isSelected[0],
                                                      selectedColor: Color(
                                                        0xFF00CEC9,
                                                      ),
                                                      backgroundColor: Color(
                                                        0x8000CEC9,
                                                      ),
                                                      checkmarkColor: Color(
                                                        0xFFFCFBFB,
                                                      ),
                                                      side: BorderSide(
                                                        color: Color(
                                                          0xFF1E272E,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    FilterChip(
                                                      label: Text(
                                                        "Rating",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      onSelected: (selected) {
                                                        setState(() {
                                                          isSelected[1] =
                                                              selected;

                                                          // Handle sort by popularity
                                                          print(
                                                            "Sort by Rating",
                                                          );
                                                        });
                                                      },
                                                      elevation: 4.0,
                                                      selected: isSelected[1],
                                                      selectedColor: Color(
                                                        0xFF00CEC9,
                                                      ),
                                                      backgroundColor: Color(
                                                        0x8000CEC9,
                                                      ),
                                                      checkmarkColor: Color(
                                                        0xFFFCFBFB,
                                                      ),
                                                      side: BorderSide(
                                                        color: Color(
                                                          0xFF1E272E,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    FilterChip(
                                                      label: Text(
                                                        "Newest",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      onSelected: (selected) {
                                                        setState(() {
                                                          isSelected[2] =
                                                              selected;

                                                          // Handle sort by popularity
                                                          print(
                                                            "Sort by Newest",
                                                          );
                                                        });
                                                      },
                                                      elevation: 4.0,
                                                      selected: isSelected[2],
                                                      selectedColor: Color(
                                                        0xFF00CEC9,
                                                      ),
                                                      backgroundColor: Color(
                                                        0x8000CEC9,
                                                      ),
                                                      checkmarkColor: Color(
                                                        0xFFFCFBFB,
                                                      ),
                                                      side: BorderSide(
                                                        color: Color(
                                                          0xFF1E272E,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 30.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle apply filters
                                                print("Apply filters");

                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      Color(0xFF0984E3),
                                                    ),
                                                padding: WidgetStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                  ),
                                                ),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                  color: Color(0xFFF5F6FA),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_list, size: 20.0),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      "Programming Foundations",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...courseCardList["Programming Foundations"]!,
                    SizedBox(height: 30.0),
                    Text("Database Structures",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...courseCardList["Database Structures"]!,
                    SizedBox(height: 30.0),
                    Text(
                      "Framework Development",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...courseCardList["Framework Development"]!,
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              // Expanded(
              //   child: ListView(
              //     children: <Widget>[
              //       Text(
              //         "Beginner Courses",
              //         style: TextStyle(
              //           fontSize: 18.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Flutter for Beginners"),
              //           subtitle: Text(
              //             "Learn the basics of Flutter development.",
              //           ),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Flutter for Beginners");
              //           },
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Dart Programming"),
              //           subtitle: Text("Master the Dart programming language."),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Dart Programming");
              //           },
              //         ),
              //       ),
              //       SizedBox(height: 20.0),
              //       Text(
              //         "Intermediate Courses",
              //         style: TextStyle(
              //           fontSize: 18.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Flutter State Management"),
              //           subtitle: Text(
              //             "Explore various state management techniques in Flutter.",
              //           ),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Flutter State Management");
              //           },
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Flutter Animations"),
              //           subtitle: Text(
              //             "Learn how to create stunning animations in Flutter.",
              //           ),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Flutter Animations");
              //           },
              //         ),
              //       ),
              //       SizedBox(height: 20.0),
              //       Text(
              //         "Expert Courses",
              //         style: TextStyle(
              //           fontSize: 18.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Flutter Performance Optimization"),
              //           subtitle: Text(
              //             "Learn techniques to optimize the performance of your Flutter apps.",
              //           ),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Flutter Performance Optimization");
              //           },
              //         ),
              //       ),
              //       SizedBox(height: 10.0),
              //       Card(
              //         elevation: 4.0,
              //         clipBehavior: Clip.hardEdge,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20.0,
              //             backgroundImage: NetworkImage(
              //               "https://cdn-icons-png.flaticon.com/128/5968/5968350.png",
              //             ),
              //           ),
              //           title: Text("Flutter Architecture Patterns"),
              //           subtitle: Text(
              //             "Explore different architecture patterns for building scalable Flutter apps.",
              //           ),
              //           trailing: const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16.0,
              //           ),
              //           onTap: () {
              //             // Handle course tap
              //             print("Tapped on Flutter Architecture Patterns");
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
