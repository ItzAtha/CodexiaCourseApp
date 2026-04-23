import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble {
  final BuildContext context;
  final String message;
  final bool isUser;

  ChatBubble({required this.context, required this.message, required this.isUser});

  Widget build() {
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: isUser
            ? Text(
                message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              )
            : Text.rich(TextSpan(children: [..._format()])),
      ),
    );
  }

  List<InlineSpan> _format() {
    int currentTableLine = 1;
    bool isCodeTextFound = false;

    String? codeLanguage;
    List<String> codeBlockText = [];
    List<String> separateText = message.split('\n');

    List<InlineSpan> widgetSpan = [];
    Map<int, List<InlineSpan>> tableTextWidget = {};

    for (var line in separateText) {
      RegExp isHasAccent = RegExp(r'(\`)');
      RegExp isHasHashtag = RegExp(r'(\#{3})');
      RegExp isHasAsterisk = RegExp(r'(\*{2})');
      RegExp isHasPipe = RegExp(r'(\|)');
      RegExp isURL = RegExp(r'(https?:\/\/\S+)');

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
      } else if (!isCodeTextFound && line.contains(isHasPipe)) {
        List<InlineSpan> tableLineWidget = [];
        final List<String> separateLine = line.split('|');

        if (currentTableLine == 2) {
          currentTableLine++;
          continue;
        }

        for (int i = 0; i < separateLine.length; i++) {
          if (separateLine[i].isEmpty) continue;

          int currentIndex = 0;
          int nextIndex = currentIndex + 1;
          bool isAsteriskFound = false;

          final List<String> currentText = [];
          final List<String> separateText = separateLine[i].split('');

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
              tableLineWidget.add(
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
                if (!nextChar.endsWith(' ')) {
                  currentText.add("$nextChar\n");
                }
              } else {
                currentText.add("\n");
              }

              tableLineWidget.add(
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

        tableLineWidget.removeWhere((element) => element.toPlainText().trim() == '');
        tableTextWidget[currentTableLine] = tableLineWidget;

        ScrollController scrollController = ScrollController();
        if (currentTableLine == 1) {
          widgetSpan.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Column(
                children: <Widget>[
                  Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FixedColumnWidth(150.0),
                          1: FixedColumnWidth(150.0),
                          2: FixedColumnWidth(150.0),
                        },
                        children: <TableRow>[
                          for (var tableLine in tableTextWidget.entries)
                            TableRow(
                              children: <Widget>[
                                for (var textWidget in tableLine.value)
                                  Text.rich(textWidget, textAlign: TextAlign.center),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          );
        } else {
          widgetSpan.last = WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Column(
              children: <Widget>[
                Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FixedColumnWidth(150.0),
                        1: FixedColumnWidth(150.0),
                        2: FixedColumnWidth(150.0),
                      },
                      children: <TableRow>[
                        for (var tableLine in tableTextWidget.entries)
                          TableRow(
                            children: <Widget>[
                              for (var textWidget in tableLine.value)
                                Text.rich(textWidget, textAlign: TextAlign.center),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          );
        }

        currentTableLine++;
      } else if (!isCodeTextFound && line.contains(isURL)) {
        int currentIndex = 0;
        int nextIndex = currentIndex + 1;
        bool isAsteriskFound = false;
        bool isParenthesesFound = false;

        final List<String> currentText = [];
        final List<String> currentLink = [];
        final List<String> separateText = line.split('');

        RegExp asterisk = RegExp(r'(\*)');

        for (int i = 0; i < separateText.length - 1; i++) {
          String currentChar = separateText[currentIndex];
          String nextChar = separateText[nextIndex];

          if (currentIndex == 0 && (currentChar.contains(asterisk) && nextChar.contains(" "))) {
            currentText.add(currentChar);
          }

          if (!currentChar.contains(asterisk)) {
            if (currentChar.contains('(') || currentChar.contains(')')) {
              isParenthesesFound = !isParenthesesFound;
            } else if (isParenthesesFound) {
              currentLink.add(currentChar);
            } else {
              currentText.add(currentChar);
            }
          }

          if (currentChar.contains(asterisk) && nextChar.contains(asterisk)) {
            if (currentLink.isNotEmpty) {
              String parseLink = currentLink.join();

              widgetSpan.add(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: currentText.join(),
                      style: TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.lightBlue,
                        decorationThickness: 2.0,
                        fontWeight: isAsteriskFound ? FontWeight.bold : FontWeight.normal,
                        color: Colors.lightBlue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Uri url = Uri.parse(parseLink);
                          launchUrl(url);
                        },
                    ),
                  ],
                ),
              );
              currentLink.clear();
            } else {
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
            }

            currentText.clear();
            isAsteriskFound = !isAsteriskFound;
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
          codeLanguage ??= line.replaceAll(threeAccent, '').trim();
          String capitalizedCodeLang = codeLanguage[0].toUpperCase() + codeLanguage.substring(1);

          if (isCodeTextFound) {
            String newText = codeBlockText.join('\n').replaceAll(threeAccent, '');

            ScrollController scrollController = ScrollController();
            widgetSpan.add(
              WidgetSpan(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            capitalizedCodeLang,
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.labelSmall?.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: newText));
                            },
                            icon: Icon(Icons.copy),
                            color: Color(0xFF00CEC9),
                            iconSize: 20.0,
                            style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(Size(40.0, 40.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4.0),
                          bottomRight: Radius.circular(4.0),
                        ),
                      ),
                      child: RawScrollbar(
                        controller: scrollController,
                        thumbColor: Colors.grey.shade700,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              newText,
                              style: GoogleFonts.sourceCodePro(
                                fontSize: newText.split(' ').length > 15 ? 12.0 : 14.0,
                                color: Theme.of(context).textTheme.labelSmall?.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            widgetSpan.add(TextSpan(text: "\n"));
            codeBlockText.clear();
            codeLanguage = null;
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

    if (widgetSpan.last.toPlainText() == '\n') {
      widgetSpan.removeLast();
    }

    return widgetSpan;
  }
}
