// Version: 0.0.0
import 'dart:async';
import 'arguments.dart';

abstract class Command {
  String get name;
  String get description;
  String get usage => 'dart run bin/dartpedia.dart $name';

  List<Argument> get options => const [];

  FutureOr<CommandStatus> run(ArgResults results);
}
