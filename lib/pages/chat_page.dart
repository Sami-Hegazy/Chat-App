import 'package:chat_app/component/constant.dart';
import 'package:chat_app/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/chat_bubble.dart';
import '../helper/snack_bar.dart';
import '../model/message.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  static String id = 'chatPage';

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final controllerList = ScrollController();
    List<Message> messageList = [];
    String email = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4DA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/images/scholar.png'),
            ),
            const SizedBox(width: 8),
            const Text('Chat App'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messageList = state.messagesList;
                } else if (state is ChatFailure) {
                  showCustomSnackbar(
                      context, state.errorMessage, Icons.error, kPrimaryColor);
                }
              },
              builder: (context, state) {
                return ListView.builder(
                    reverse: true,
                    controller: controllerList,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return messageList[index].id == email
                          ? ChatBubbleFirstUser(message: messageList[index])
                          : ChatBubbleSecondUser(message: messageList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: value, email: email);
                controller.clear();
                //move to last item in listView with animation
                controllerList.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              },
              style: const TextStyle(color: kPrimaryColor),
              // keyboardType: TextInputType.,
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    color: kPrimaryColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
