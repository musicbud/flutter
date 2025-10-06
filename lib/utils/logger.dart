import 'package:logger/logger.dart';

/// Global logger instance for easy debugging throughout the app
final logger = Logger(
  level: Level.debug,
  printer: PrettyPrinter(),
);