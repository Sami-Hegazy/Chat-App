part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  final List<Message> messagesList;
  ChatSuccess({
    required this.messagesList,
  });
}

class ChatFailure extends ChatState {
  final String errorMessage;

  ChatFailure({required this.errorMessage});
}
