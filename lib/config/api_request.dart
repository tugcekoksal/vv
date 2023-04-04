import 'dart:collection';

class FunctionsQueue {
  static Future<void> execute() async {
    while (failedRequestFunctions.isNotEmpty) {
      try {
        await failedRequestFunctions.first();
        failedRequestFunctions.removeFirst();
      } catch (e) {
        break;
      }
    }
  }
}

final Queue<Future<void> Function()> failedRequestFunctions = Queue();
