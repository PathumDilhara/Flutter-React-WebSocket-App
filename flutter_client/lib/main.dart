import 'package:flutter/material.dart';
import 'package:flutter_client/screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Chat App", home: ChatScreen());
  }
}
