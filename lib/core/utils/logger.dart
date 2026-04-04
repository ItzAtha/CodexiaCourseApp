import 'package:logger/logger.dart';

enum LogLevel { debug, info, warning, error, trace }

class DebugLogger {
  final Object _message;
  final LogLevel _level;
  final StackTrace? _stackTrace;

  late final Logger _logger;

  DebugLogger({required Object message, required LogLevel level, StackTrace? stackTrace})
    : _stackTrace = stackTrace,
      _level = level,
      _message = message {
    _logger = Logger(printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime));
    assert(
      stackTrace == null || _level == LogLevel.error,
      'Stack trace must be provided for error logs.',
    );
  }

  void log() {
    switch (_level) {
      case LogLevel.debug:
        _logger.d(_message);
        break;
      case LogLevel.info:
        _logger.i(_message);
        break;
      case LogLevel.warning:
        _logger.w(_message);
        break;
      case LogLevel.error:
        _logger.e(_message, stackTrace: _stackTrace);
        break;
      case LogLevel.trace:
        _logger.t(_message);
        break;
    }
  }
}
