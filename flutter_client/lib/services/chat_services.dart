import 'package:web_socket_channel/web_socket_channel.dart';

class ChatServices {
  final WebSocketChannel _webSocketChannel = WebSocketChannel.connect(
    Uri.parse("ws://192.168.228.201:4000"),
  );

  WebSocketChannel get webSocketChannel=> _webSocketChannel;

  void sendMessage (String message){
    // In this method stream is maintained
    if(message.isNotEmpty){
      _webSocketChannel.sink.add(message);
    }
  }

 void dispose(){
    _webSocketChannel.sink.close();
  }
}
