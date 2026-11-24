// Version: 0.0.0
import 'dart:io';
import 'package:logging/logging.dart';

Logger initFileLogger(String loggerName, {String logDir = 'logs'}) {
  final directory = Directory(logDir);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  final logFile = File('${directory.path}/dartpedia.log');
  final sink = logFile.openWrite(mode: FileMode.append);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final line =
        '[${record.time.toIso8601String()}] [${record.level.name}] [${record.loggerName}] ${record.message}';
    sink.writeln(line);
    if (record.error != null) {
      sink.writeln('  Erro: ${record.error}');
    }
    if (record.stackTrace != null) {
      sink.writeln('  StackTrace: ${record.stackTrace}');
    }
  });

  return Logger(loggerName);
}
