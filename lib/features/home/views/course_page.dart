import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:codexia_course_learning/shared/providers/course_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import '../../../core/app_constants.dart' show ToastAnimations;
import '../../../core/utils/logger.dart';
import '../widgets/course_card.dart';

enum FilterType { popular, rating, newest, clear }

class CoursePage extends ConsumerStatefulWidget {
  const CoursePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursePageState();
}

class _CoursePageState extends ConsumerState<CoursePage> {
  ({bool newest, bool popular, bool rating}) filterData = (
    popular: false,
    rating: false,
    newest: false,
  );
  Map<CourseType, List<CourseCard>> courseList = {};
  Map<CourseType, List<CourseCard>> filteredList = {};
  TextEditingController searchController = TextEditingController();

  void updateFilterData(({bool newest, bool popular, bool rating}) data) {
    setState(() {
      filterData = data;
    });
  }

  void searchFilterList(String search) {
    setState(() {
      filteredList = courseList.map((type, data) {
        return MapEntry(
          type,
          data
              .where((course) => course.title.toLowerCase().contains(search.toLowerCase()))
              .toList(),
        );
      });
    });
  }

  void filterList(FilterType type) {
    switch (type) {
      case FilterType.popular:
        List<CourseCard> tempCourseList = [];

        for (final course in courseList.keys) {
          tempCourseList.addAll(courseList[course] ?? []);
        }

        tempCourseList.sort((a, b) => b.popular.compareTo(a.popular));
        setState(() {
          filteredList.clear();
          filteredList[CourseType.popularCourse] = tempCourseList.take(10).toList();
        });
        break;
      case FilterType.rating:
        List<CourseCard> tempCourseList = [];

        for (final course in courseList.keys) {
          tempCourseList.addAll(courseList[course] ?? []);
        }

        tempCourseList.sort((a, b) => b.rating.compareTo(a.rating));
        setState(() {
          filteredList.clear();
          filteredList[CourseType.topRateCourse] = tempCourseList.take(10).toList();
        });
        break;
      case FilterType.newest:
        setState(() {
          filteredList.clear();
          filteredList = courseList.map((type, data) {
            return MapEntry(
              type,
              data.where((course) {
                Duration diff = DateTime.now().difference(course.createdAt);
                if (diff.inDays < 2) {
                  return true;
                }
                return false;
              }).toList(),
            );
          });
        });
        break;
      case FilterType.clear:
        setState(() {
          filteredList.clear();
          filteredList.addAll(courseList);

          filterData = (popular: false, rating: false, newest: false);
        });
        break;
    }
  }

  List<Widget> getCourseList() {
    List<Widget> courseList = [];

    for (final type in filteredList.keys) {
      if (filteredList[type]?.isEmpty ?? true) continue;

      courseList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              type.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelMedium?.color,
              ),
            ),
            for (CourseCard element in filteredList[type] ?? []) element.create(context),
            const SizedBox(height: 15.0),
          ],
        ),
      );
    }

    return courseList.reversed.toList();
  }

  Widget noCourses() {
    return Column(
      children: <Widget>[
        Text(
          "No courses found!",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.labelSmall?.color,
          ),
        ),
        Text(
          "Try to search another course.",
          style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.labelSmall?.color),
        ),
      ],
    );
  }

  Widget loadingCourses() {
    return Column(
      children: <Widget>[
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xCC00CEC9)),
        ),
        const SizedBox(height: 15.0),
        Text(
          "Loading courses...",
          style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.labelSmall?.color),
        ),
      ],
    );
  }

  void _initializeCourseLists(List<Course> data) {
    courseList.clear();

    Map<CourseType, List<Course>> coursesData = data.fold({}, (
      Map<CourseType, List<Course>> map,
      course,
    ) {
      CourseType type = CourseType.values.firstWhere((level) => level == course.type);
      map.putIfAbsent(type, () => []).add(course);
      return map;
    });

    for (final courses in coursesData.entries) {
      List<CourseCard> cardList = [];
      CourseType courseType = courses.key;

      for (final courseData in courses.value) {
        CourseCard card = CourseCard(
          courseData.courseId,
          courseData.title,
          courseData.description,
          courseData.rating,
          courseData.popular,
          courseData.validLevels,
          courseData.createdAt,
          courseData.isActive,
        );
        cardList.add(card);
      }

      cardList.sort((a, b) => a.title.compareTo(b.title));
      courseList[courseType] = cardList;
    }

    filteredList.clear();
    filteredList.addAll(courseList);
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseListProvider);

    if (courseList.isEmpty && courseState.hasValue) {
      _initializeCourseLists(courseState.requireValue);
    }

    ref.listen(courseListProvider, (previous, next) {
      next.when(
        data: (data) {
          setState(() {
            _initializeCourseLists(data);
          });
        },
        error: (error, stackTrace) {
          DebugLogger(
            message: "Error loading course data: $error",
            stackTrace: stackTrace,
            level: LogLevel.error,
          ).log();
          Toastification().show(
            context: context,
            title: const Text("Couldn't load course"),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            alignment: Alignment.bottomCenter,
            autoCloseDuration: ToastAnimations.closeDuration,
            animationDuration: ToastAnimations.animationDuration,
          );
        },
        loading: () {
          DebugLogger(message: "Loading courses...", level: LogLevel.info).log();
        },
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 45.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SearchBar(
                        controller: searchController,
                        leading: const Icon(Icons.search, size: 20.0),
                        trailing: <Widget>[
                          if (searchController.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                DebugLogger(
                                  message: "Clear search input",
                                  level: LogLevel.debug,
                                ).log();

                                searchFilterList("");
                                searchController.clear();
                              },
                              icon: const Icon(Icons.clear, size: 20.0),
                            ),
                        ],
                        padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10.0)),
                        hintText: "Search for courses",
                        onChanged: (value) {
                          DebugLogger(message: "Search input: $value", level: LogLevel.debug).log();
                          searchFilterList(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    SizedBox(
                      width: 45.0,
                      height: 45.0,
                      child: Material(
                        elevation:
                            Theme.of(context).iconButtonTheme.style?.elevation?.resolve({}) ?? 0.0,
                        shape: Theme.of(context).iconButtonTheme.style?.shape?.resolve({}),
                        child: IconButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) {
                                return FilterSelector(
                                  filterData: filterData,
                                  onFilterChange: updateFilterData,
                                  onFilterUpdate: filterList,
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_list, size: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Expanded(
                child: filteredList.values.any((courses) => courses.isNotEmpty) == true
                    ? ListView(children: <Widget>[...getCourseList(), const SizedBox(height: 30.0)])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[courseState.isLoading ? loadingCourses() : noCourses()],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.filterData,
    required this.onFilterChange,
    required this.onFilterUpdate,
  });

  final ({bool newest, bool popular, bool rating}) filterData;
  final Function(FilterType) onFilterUpdate;
  final Function(({bool newest, bool popular, bool rating})) onFilterChange;

  @override
  State<StatefulWidget> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  late ({bool newest, bool popular, bool rating}) isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.filterData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Filter Courses",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.labelMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          Text(
            "Sort by",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.labelSmall?.color,
            ),
          ),
          Divider(thickness: 0.8, color: Colors.grey.shade300, height: 10.0),
          const SizedBox(height: 10.0),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FilterChip(
                    label: const Text("Popular", style: TextStyle(fontSize: 14.0)),
                    onSelected: (selected) {
                      setState(() {
                        isSelected = (popular: selected, rating: false, newest: false);
                      });
                      widget.onFilterChange(isSelected);
                    },
                    selected: isSelected.popular,
                  ),
                  FilterChip(
                    label: const Text("Rating", style: TextStyle(fontSize: 14.0)),
                    onSelected: (selected) {
                      setState(() {
                        isSelected = (popular: false, rating: selected, newest: false);
                      });
                      widget.onFilterChange(isSelected);
                    },
                    selected: isSelected.rating,
                  ),
                  FilterChip(
                    label: const Text("Newest", style: TextStyle(fontSize: 14.0)),
                    onSelected: (selected) {
                      setState(() {
                        isSelected = (popular: false, rating: false, newest: selected);
                      });
                      widget.onFilterChange(isSelected);
                    },
                    selected: isSelected.newest,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    isSelected = (popular: false, rating: false, newest: false);

                    widget.onFilterUpdate(FilterType.clear);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    side: BorderSide(color: Colors.grey.shade600),
                    minimumSize: const Size(120.0, 40.0),
                  ),
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isSelected.popular) {
                      widget.onFilterUpdate(FilterType.popular);
                    }

                    if (isSelected.rating) {
                      widget.onFilterUpdate(FilterType.rating);
                    }

                    if (isSelected.newest) {
                      widget.onFilterUpdate(FilterType.newest);
                    }

                    if (!isSelected.popular && !isSelected.rating && !isSelected.newest) {
                      widget.onFilterUpdate(FilterType.clear);
                    }

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Color(0xFF0984E3)),
                    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12.0)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    minimumSize: const WidgetStatePropertyAll(Size(120.0, 40.0)),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Color(0xFFF5F6FA), fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
