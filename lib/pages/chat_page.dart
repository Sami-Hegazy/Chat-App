import 'package:chat_app/component/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../component/chat_bubble.dart';
import '../model/message.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'chatPage';
  TextEditingController controller = TextEditingController();
  final _controllerList = ScrollController();
  CollectionReference message =
      FirebaseFirestore.instance.collection('Message');

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: message.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messageList = [];
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              messageList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
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
                    child: ListView.builder(
                        reverse: true,
                        controller: _controllerList,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          return messageList[index].id == email
                              ? ChatBubbleFirstUser(message: messageList[index])
                              : ChatBubbleSecondUser(
                                  message: messageList[index]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (value) {
                        message.add({
                          kMessage: value,
                          kCreatedAt: DateTime.now(),
                          'id': email,
                        });
                        controller.clear();
                        //move to last item in listView with animation
                        _controllerList.animateTo(
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
          } else {
            return const Text('Loading...');
          }
        });
  }
}
