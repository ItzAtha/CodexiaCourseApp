import 'package:flutter/material.dart';

class AIChatText {
  final String text;

  AIChatText(this.text);

  List<InlineSpan> format(BuildContext context) {
    int currentIndex = 0;
    int? indexCodeAsterisk1;
    int? indexCodeAsterisk2;

    List<InlineSpan> widgetSpan = [];
    List<String> separateText = text.split('\n');

    for (var line in separateText) {
      RegExp isHasAccent = RegExp(r'(\`)');
      RegExp isHasHashtag = RegExp(r'(\#{3})');
      RegExp isHasAsterisk = RegExp(r'(\*{2})');

      if (line.contains(isHasHashtag)) {
        String newLine = line.replaceAll(isHasHashtag, '').trim();
        widgetSpan.add(
          TextSpan(
            text: "$newLine\n",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.labelMedium?.color,
            ),
          ),
        );
      } else if (line.contains(isHasAsterisk)) {
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
          if (indexCodeAsterisk1 == null) {
            indexCodeAsterisk1 = currentIndex;
          } else {
            indexCodeAsterisk2 = currentIndex;

            List<String> separateCodeLine = separateText
                .getRange(indexCodeAsterisk1 + 1, indexCodeAsterisk2 + 1)
                .toList();
            String codeLine = separateCodeLine.join('\n');
            String newLine = codeLine.replaceAll(threeAccent, '');

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
                          newLine,
                          style: TextStyle(
                            fontSize: newLine.split(' ').length > 15 ? 12.0 : 14.0,
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

            widgetSpan.add(TextSpan(text: "\n", style: TextStyle(fontSize: 16.0)));

            indexCodeAsterisk1 = null;
            indexCodeAsterisk2 = null;
          }
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
        if (indexCodeAsterisk1 == null) {
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

      currentIndex++;
    }

    return widgetSpan;
  }
}
