import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'dart:typed_data';

class Connection {
  var buffer = List<Uint8>();
  Connection(Socket socket) {
    socket.listen((data) {
      try {      
          final len = ByteData.view(data.sublist(0,4).buffer).getInt32(0);
          
      } catch (e) {}
    }, onError: () {}, onDone: () {}, cancelOnError: true);
  }
}

class Service {
  Future<int> start({int port = 0}) async {
    var serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await for (var socket in serverSocket) {
      socket.listen((data) {
        final head = data.sublist(0, 3);
      });
    }

    return serverSocket.port;
  }
}
