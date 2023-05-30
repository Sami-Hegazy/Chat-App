import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // BlocOverrides.runZoned(
  //   () {
  //     runApp(const ChatApp());
  //   },
  //   blocObserver: SimpleBlocObserver(),
  // );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocObserver();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        routes: routes,
        initialRoute: LoginPage.id,
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  ChatPage.id: (BuildContext context) => const ChatPage(),
  LoginPage.id: (BuildContext context) => const LoginPage(),
  RegisterPage.id: (BuildContext context) => const RegisterPage(),
};
