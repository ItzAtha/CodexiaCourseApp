import 'package:flutter/material.dart';

class AIChatText {
  final String text;

  AIChatText(this.text);

  List<InlineSpan> format(BuildContext context) {
    bool isCodeTextFound = false;

    List<String> codeBlockText = [];
    List<String> separateText = text.split('\n');

    List<InlineSpan> widgetSpan = [];

    for (var line in separateText) {
      RegExp isHasAccent = RegExp(r'(\`)');
      RegExp isHasHashtag = RegExp(r'(\#{3})');
      RegExp isHasAsterisk = RegExp(r'(\*{2})');

      if (!isCodeTextFound && line.contains(isHasHashtag)) {
        RegExp twoHashtag = RegExp(r'(\#{2})');
        RegExp threeHashtag = RegExp(r'(\#{3})');

        String newLine = line.replaceAll(RegExp(r'(\#{2,3})'), '').trim();
        widgetSpan.add(
          TextSpan(
            text: "$newLine\n",
            style: TextStyle(
              fontSize: line.contains(threeHashtag)
                  ? 22.0
                  : line.contains(twoHashtag)
                  ? 20.0
                  : 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.labelMedium?.color,
            ),
          ),
        );
      } else if (!isCodeTextFound && line.contains(isHasAsterisk)) {
        int currentIndex = 0;
        int nextIndex = currentIndex + 1;
        bool isAsteriskFound = false;

        final List<String> currentText = [];
        final List<String> separateText = line.split('');

        RegExp asterisk = RegExp(r'(\*)');

        for (int i = 0; i < separateText.length - 1; i++) {
          String currentChar = separateText[currentIndex];
          String nextChar = separateText[nextIndex];

          if (currentIndex == 0 && (currentChar.contains(asterisk) && nextChar.contains(" "))) {
            currentText.add(currentChar);
          }

          if (!currentChar.contains(asterisk)) {
            currentText.add(currentChar);
          }

          if (currentChar.contains(asterisk) && nextChar.contains(asterisk)) {
            widgetSpan.add(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: currentText.join(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: isAsteriskFound ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            );

            isAsteriskFound = !isAsteriskFound;
            currentText.clear();
          }

          nextIndex++;
          currentIndex++;

          if (currentIndex == separateText.length - 1) {
            if (!nextChar.contains(asterisk)) {
              currentText.add("$nextChar\n");
            } else {
              currentText.add("\n");
            }

            widgetSpan.add(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: currentText.join(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }
        }
      } else if (line.contains(isHasAccent)) {
        RegExp threeAccent = RegExp(r'(\`{3})');

        if (line.contains(threeAccent)) {
          if (isCodeTextFound) {
            String newText = codeBlockText.join('\n').replaceAll(threeAccent, '');

            ScrollController scrollController = ScrollController();
            widgetSpan.add(
              WidgetSpan(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          newText,
                          style: TextStyle(
                            fontSize: newText.split(' ').length > 15 ? 12.0 : 14.0,
                            fontFamily: 'monospace',
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );

            widgetSpan.add(TextSpan(text: "\n"));
            codeBlockText.clear();
          }

          isCodeTextFound = !isCodeTextFound;
        } else {
          int currentIndex = 0;
          bool isAccentFound = false;

          final List<String> currentText = [];
          final List<String> separateText = line.split('');

          RegExp accent = RegExp(r'(\`)');

          for (int i = 0; i < separateText.length - 1; i++) {
            String currentChar = separateText[currentIndex];

            if (!currentChar.contains(accent)) {
              currentText.add(currentChar);
            }

            if (currentChar.contains(accent)) {
              if (isAccentFound) {
                widgetSpan.add(
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        border: Border.all(color: Colors.black45),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        currentText.join(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                widgetSpan.add(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: currentText.join(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                        ),
                      ),
                    ],
                  ),
                );
              }

              isAccentFound = !isAccentFound;
              currentText.clear();
            }

            currentIndex++;

            if (currentIndex == separateText.length - 1) {
              currentText.add("\n");

              widgetSpan.add(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: currentText.join(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).textTheme.labelSmall?.color,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }
      } else {
        if (isCodeTextFound) {
          codeBlockText.add(line);
        } else {
          widgetSpan.add(
            TextSpan(
              text: "$line\n",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
          );
        }
      }
    }

    return widgetSpan;
  }
}
