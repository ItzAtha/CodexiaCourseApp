import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_lesson.freezed.dart';
part 'course_lesson.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum MaterialContentType {
  explain("Explain"),
  hint("Hint"),
  important("Important"),
  conclusion("Conclusion"),
  codeSandbox("Code Sandbox");

  final String name;

  const MaterialContentType(this.name);
}

@Freezed(unionKey: 'type')
sealed class CourseLesson with _$CourseLesson {
  const CourseLesson._();

  @FreezedUnionValue("MATERIAL")
  const factory CourseLesson.material({
    @JsonKey(name: 'id') required String lessonId,

    required String title,

    @Default("") String imageUrl,
    @Default({}) Map<MaterialContentType, String> content,
  }) = MaterialLesson;

  @FreezedUnionValue("MULTIPLE_CHOICE_QUIZ")
  const factory CourseLesson.multipleChoiceQuiz({
    @JsonKey(name: 'id') required String lessonId,

    required String title,
    required String question,
    required List<String> options,
    required int correctAnswerIndex,
    required String feedback,

    @Default("") String imageUrl,
  }) = MultipleChoiceQuiz;

  @FreezedUnionValue("DRAG_AND_DROP_QUIZ")
  const factory CourseLesson.dragAndDropQuiz({
    @JsonKey(name: 'id') required String lessonId,

    required String title,
    required String question,
    required List<Map<String, dynamic>> draggableBlocks,
    required List<String> correctSequence,
    required String feedback,

    @Default("") String imageUrl,
  }) = DragAndDropQuiz;

  @FreezedUnionValue("CODE_SANDBOX_QUIZ")
  const factory CourseLesson.codeSandboxQuiz({
    @JsonKey(name: 'id') required String lessonId,

    required String title,
    required String question,
    required String language,
    required String initialCode,
    required List<Map<String, dynamic>> testCase,
    required String feedback,
  }) = CodeSandboxQuiz;

  @FreezedUnionValue("COORDINATE_HOTSPOT_QUIZ")
  const factory CourseLesson.coordinateHotspotQuiz({
    @JsonKey(name: 'id') required String lessonId,

    required String title,
    required String question,

    @Default("") String imageUrl,

    required Map<String, dynamic> targetArea,
    required String feedback,
  }) = CoordinateHotspotQuiz;

  factory CourseLesson.fromJson(Map<String, dynamic> json) => _$CourseLessonFromJson(json);
}
