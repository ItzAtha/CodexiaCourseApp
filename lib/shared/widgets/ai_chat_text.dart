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

      // TODO: Make support if text has both accent and asterisk
      // if (line.contains(isHasAccent) && line.contains(isHasAsterisk)) {
      //   log("Line contains both accent and asterisk: $line");
      // }
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
        // TODO: Make support if in 1 text line there are 2 bold text
        int startIndex = line.indexOf(isHasAsterisk);
        int endIndex = line.lastIndexOf(isHasAsterisk) + 2;

        String newFirstLine = line.substring(0, startIndex);
        String newLastLine = line.substring(endIndex);
        String newAsteriskLine = line.substring(startIndex, endIndex);
        newAsteriskLine = newAsteriskLine.replaceAll(isHasAsterisk, '');

        widgetSpan.add(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: newFirstLine,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
              TextSpan(
                text: newAsteriskLine,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
              TextSpan(
                text: "$newLastLine\n",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
            ],
          ),
        );
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
          int? indexAccent1;
          int? indexAccent2;

          int currentIndex = 0;
          List<String> textLine = [];
          List<InlineSpan> textSpan = [];
          List<String> separateAccent = line.split('');

          for (var accent in separateAccent) {
            if (accent.contains(isHasAccent)) {
              if (indexAccent1 == null) {
                indexAccent1 = currentIndex;

                textSpan.add(
                  TextSpan(
                    text: textLine.join(''),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                );
                textLine.clear();
              } else {
                indexAccent2 = currentIndex;
                List<String> separateAccentLine = separateAccent
                    .getRange(indexAccent1, indexAccent2 + 1)
                    .toList();

                String accentLine = separateAccentLine.join('');
                String newLine = accentLine.replaceAll(isHasAccent, '');

                textSpan.add(
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        border: Border.all(color: Colors.black45),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        newLine,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.labelSmall?.color,
                        ),
                      ),
                    ),
                  ),
                );

                indexAccent1 = null;
                indexAccent2 = null;
              }
            } else {
              if (indexAccent1 == null) {
                textLine.add(accent);
              }
            }

            currentIndex++;
          }

          textSpan.add(
            TextSpan(
              text: '.\n',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
          );

          widgetSpan.addAll(textSpan);
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
