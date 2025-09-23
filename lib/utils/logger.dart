import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final Logger _logger = Logger(
    filter: ProductionFilter(),
    printer: CustomPrinter(), // Use custom printer for timestamps
    level: kReleaseMode ? Level.error : Level.debug,
  );

  // For general information
  static void info(String message) {
    _logger.i(message);
  }

  // For debug messages (disabled in production)
  static void debug(String message) {
    _logger.d(message);
  }

  // For warnings
  static void warning(String message) {
    _logger.w(message);
  }

  // For errors
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toString().split('.').first;
    final errorDetails = error != null ? "[${error.runtimeType}] ${error.toString()}" : "Unknown error";
    
    _logger.e("[$timestamp] $message\n$errorDetails", error: error, stackTrace: stackTrace);
  }

  // For serious crashes
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

// Custom printer that includes timestamps
class CustomPrinter extends LogPrinter {
  final PrettyPrinter _prettyPrinter = PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    // printTime is removed
  );

  @override
  List<String> log(LogEvent event) {
    final timestamp = DateTime.now().toString().split('.').first;
    final originalLog = _prettyPrinter.log(event);
    
    // Add timestamp to the first line
    if (originalLog.isNotEmpty) {
      originalLog[0] = '[$timestamp] ${originalLog[0]}';
    }
    
    return originalLog;
  }
}

// Filter that allows all logs in debug mode, but only errors in production
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode) {
      return event.level.value >= Level.error.value;
    }
    return true;
  }
}