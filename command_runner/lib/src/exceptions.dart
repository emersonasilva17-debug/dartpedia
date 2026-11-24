// Version: 0.0.0

class ArgumentException implements Exception {
  final String message;
  final String? command;
  final String? argument;

  const ArgumentException(
    this.message, {
    this.command,
    this.argument,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ArgumentException: $message');
    if (command != null) {
      buffer.write(' (comando: "$command")');
    }
    if (argument != null) {
      buffer.write(' [argumento: "$argument"]');
    }
    return buffer.toString();
  }
}

class CommandExecutionException implements Exception {
  final String message;
  final Object? cause;

  const CommandExecutionException(this.message, {this.cause});

  @override
  String toString() =>
      cause != null ? 'CommandExecutionException: $message ($cause)' : 'CommandExecutionException: $message';
}
