import 'package:logger/logger.dart';

Logger logger(Type type, {bool isColored = false}) => Logger(
      printer: CustomerPrinter(type.toString(), isColored),
      level: Level.verbose,
    );

class CustomerPrinter extends LogPrinter {
  final String className;
  final bool isColored;

  CustomerPrinter(this.className, this.isColored);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    if (isColored) {
      return [color!('$emoji $className: $message')];
    }
    return [('$emoji $className: $message')];
  }
}
