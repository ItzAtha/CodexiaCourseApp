import 'package:cached_network_image/cached_network_image.dart';
import 'package:codexia_course_learning/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/models/course/course_lesson.dart';

class CourseContent extends StatefulWidget {
  final List<CourseLesson> _lessons;
  final PageController? _pageController;
  final void Function(int quizIndex) _onQuizChange;

  const CourseContent({
    super.key,
    required List<CourseLesson> lessons,
    required PageController controller,
    required void Function(int quizIndex) onQuizChange,
  }) : _lessons = lessons,
       _pageController = controller,
       _onQuizChange = onQuizChange;

  @override
  State<StatefulWidget> createState() => CourseContentState();
}

class CourseContentState extends State<CourseContent> {
  Map<int, int> pickedAnswerIndex = {};
  Map<int, bool> hasAnimated = {};

  Widget buildLesson(int index, CourseLesson lesson) {
    return switch (lesson) {
      MaterialLesson() => buildMaterialLesson(lesson),
      MultipleChoiceQuiz() => buildMultipleChoiceQuiz(index, lesson),
      DragAndDropQuiz() => buildDragAndDropQuiz(lesson),
      CodeSandboxQuiz() => buildCodeSandboxQuiz(lesson),
      CoordinateHotspotQuiz() => buildCoordinateHotspotQuiz(lesson),
    };
  }

  Widget buildMaterialLesson(MaterialLesson lesson) {
    List<Widget> getContent() {
      List<Widget> contentList = [];

      if (lesson.content[MaterialContentType.explain] != null) {
        contentList.add(
          MarkdownBody(
            selectable: true,
            data: lesson.content[MaterialContentType.explain] ?? "",
            styleSheet: MarkdownStyleSheet(
              textAlign: WrapAlignment.spaceAround,
              p: Theme.of(context).textTheme.labelMedium,
              listBullet: Theme.of(context).textTheme.labelMedium,
              code: Theme.of(context).textTheme.labelMedium,
              blockquote: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        );

        contentList.add(const SizedBox(height: 12.0));
      }

      if (lesson.content[MaterialContentType.important] != null) {
        contentList.add(
          Card(
            elevation: 1.5,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: 6.0,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.p16,
                        horizontal: AppSizes.p16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16,
                              vertical: AppSizes.p8 / 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade200, Colors.blue.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  size: 12.0,
                                  color: Colors.blue.shade800,
                                ),
                                const SizedBox(width: 6.0),
                                Text(
                                  "KEY CONCEPT",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Expanded(
                            child: MarkdownBody(
                              selectable: true,
                              data: lesson.content[MaterialContentType.important] ?? "",
                              styleSheet: MarkdownStyleSheet(
                                textAlign: WrapAlignment.spaceAround,
                                p: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        contentList.add(const SizedBox(height: 12.0));
      }

      if (lesson.content[MaterialContentType.warning] != null) {
        contentList.add(
          Card(
            elevation: 1.5,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: 6.0,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.p16,
                        horizontal: AppSizes.p16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16,
                              vertical: AppSizes.p8 / 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade200, Colors.orange.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.triangleExclamation,
                                  size: 12.0,
                                  color: Colors.orange.shade800,
                                ),
                                const SizedBox(width: 6.0),
                                Text(
                                  "WARNING",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Expanded(
                            child: MarkdownBody(
                              selectable: true,
                              data: lesson.content[MaterialContentType.warning] ?? "",
                              styleSheet: MarkdownStyleSheet(
                                textAlign: WrapAlignment.spaceAround,
                                p: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        contentList.add(const SizedBox(height: 12.0));
      }

      if (lesson.content[MaterialContentType.codeSandbox] != null) {
        contentList.add(const SizedBox(height: 12.0));
      }

      if (lesson.content[MaterialContentType.conclusion] != null) {
        contentList.add(const SizedBox(height: 12.0));
      }

      return contentList;
    }

    return Column(
      children: <Widget>[
        Text(
          lesson.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8.0),
        if (lesson.imageUrl.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.p8),
            constraints: const BoxConstraints(minHeight: 200.0),
            child: CachedNetworkImage(
              imageUrl: lesson.imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
          ),
        const SizedBox(height: 8.0),
        ...getContent(),
      ],
    );
  }

  Widget buildMultipleChoiceQuiz(int index, MultipleChoiceQuiz quiz) {
    List<String> options = ['A', 'B', 'C', 'D'];

    Widget feedbackCard = Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 6.0,
              decoration: BoxDecoration(
                color: quiz.correctAnswerIndex == pickedAnswerIndex[index]
                    ? Colors.green
                    : Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.p16,
                  horizontal: AppSizes.p16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p8 / 2,
                      ),
                      decoration: BoxDecoration(
                        color: quiz.correctAnswerIndex == pickedAnswerIndex[index]
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          quiz.correctAnswerIndex == pickedAnswerIndex[index]
                              ? const FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: 12.0,
                                  color: Colors.green,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  size: 12.0,
                                  color: Colors.red,
                                ),
                          const SizedBox(width: 6.0),
                          Text(
                            quiz.correctAnswerIndex == pickedAnswerIndex[index]
                                ? "THE ANSWER IS CORRECT!"
                                : "THE ANSWER IS INCORRECT!",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: quiz.correctAnswerIndex == pickedAnswerIndex[index]
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Expanded(
                      child: MarkdownBody(
                        selectable: true,
                        data: quiz.feedback,
                        styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.spaceAround,
                          p: Theme.of(context).textTheme.labelMedium,
                          code: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!hasAnimated.containsKey(index)) {
      feedbackCard = feedbackCard
          .animate(
            onComplete: (controller) {
              setState(() => hasAnimated[index] = true);
            },
          )
          .fadeIn(duration: 500.ms);
    }

    return Column(
      children: <Widget>[
        Text(quiz.title, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8.0),
        if (quiz.imageUrl.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.p8),
            constraints: const BoxConstraints(minHeight: 200.0),
            child: CachedNetworkImage(
              imageUrl: quiz.imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
          ),
        const SizedBox(height: 8.0),
        Text(
          quiz.question,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 16.0),
        LayoutBuilder(
          builder: (context, constraints) {
            const double spacing = 16.0;
            const double runSpacing = 8.0;

            final halfWidth = (constraints.maxWidth - spacing) / 2;

            bool forceFullWidth = false;
            for (var i = 0; i < quiz.options.length; i++) {
              final text = "${options[i]}. ${quiz.options[i]}";
              if (text.length > 25) {
                forceFullWidth = true;
                break;
              }
            }

            final targetWidth = forceFullWidth ? constraints.maxWidth : halfWidth;

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < quiz.options.length; i++)
                  SizedBox(
                    width: targetWidth,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (!pickedAnswerIndex.containsKey(index)) {
                            pickedAnswerIndex[index] = i;
                            widget._onQuizChange(index);
                          }
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: pickedAnswerIndex.containsKey(index)
                            ? quiz.correctAnswerIndex == i
                                  ? const BorderSide(color: Colors.green)
                                  : const BorderSide(color: Colors.red)
                            : null,
                        overlayColor: pickedAnswerIndex.containsKey(index)
                            ? quiz.correctAnswerIndex == i
                                  ? Colors.green.shade200
                                  : Colors.red.shade200
                            : null,
                        backgroundColor: pickedAnswerIndex.containsKey(index)
                            ? quiz.correctAnswerIndex == i
                                  ? Colors.green.shade50
                                  : Colors.red.shade50
                            : null,
                        padding: const EdgeInsets.all(AppSizes.p12),
                      ),
                      child: Align(
                        alignment: AlignmentGeometry.centerStart,
                        child: Text(
                          "${options[i]}. ${quiz.options[i]}",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: pickedAnswerIndex.containsKey(index)
                                ? Colors.grey.shade800
                                : Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16.0),
        if (pickedAnswerIndex.containsKey(index)) feedbackCard,
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildDragAndDropQuiz(DragAndDropQuiz quiz) {
    return const Column();
  }

  Widget buildCodeSandboxQuiz(CodeSandboxQuiz quiz) {
    return const Column();
  }

  Widget buildCoordinateHotspotQuiz(CoordinateHotspotQuiz quiz) {
    return const Column();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget._pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget._lessons.length,
      itemBuilder: (context, index) {
        CourseLesson lesson = widget._lessons[index];

        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Center(child: buildLesson(index, lesson)),
          ),
        );
      },
    );
  }
}
