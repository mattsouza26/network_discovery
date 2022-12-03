import 'dart:isolate';

class IsolateMessageModel {
  final SendPort sendPort;
  final List<dynamic> args;
  const IsolateMessageModel(this.sendPort, {required this.args});
}
