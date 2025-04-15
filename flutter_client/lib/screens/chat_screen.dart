import 'package:flutter/material.dart';
import 'package:flutter_client/services/chat_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatServices _chatServices = ChatServices();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Listen to the stream & update the ui outside of the build method
    _chatServices.webSocketChannel.stream.listen((data) {
      print("############# received ; $data");

      String message =
          data is List<int> ? String.fromCharCodes(data) : data.toString();

      setState(() {
        _messages.add({"message": message, "isSent": false});
      });
    });
  }

  void _sendMessages() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"message": _controller.text, "isSent": true});
      });
      
      _chatServices.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _chatServices.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat App")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isSentByUser = _messages[index]["isSent"] ?? false;
                return Align(
                  alignment:
                      isSentByUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isSentByUser
                              ? Colors.blueAccent
                              : Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index]["message"] ?? "",
                      style: TextStyle(
                        color: isSentByUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessages,
                    icon: Icon(Icons.send, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
