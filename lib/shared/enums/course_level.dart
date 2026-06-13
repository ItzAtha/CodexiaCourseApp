import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CourseLevel {
  beginner("Beginner"),
  intermediate("Intermediate"),
  expert("Expert"),
  master("Master"),
  unknown("Unknown");

  final String name;

  const CourseLevel(this.name);
}
