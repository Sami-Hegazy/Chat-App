import 'package:chat_app/component/constant.dart';

class Message {
  final String message;
  final String id;
  Message({
    required this.id,
    required this.message,
  });

  factory Message.fromJson(jsonData) {
    return Message(id: jsonData['id'], message: jsonData[kMessage]);
  }
}
