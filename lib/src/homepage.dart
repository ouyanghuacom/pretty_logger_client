import 'package:flutter/material.dart';
import 'mdns_service/mdns_service.dart';
import 'package:stream/stream.dart' show StreamServer;
import 'package:socket_io/socket_io.dart' show Server, Socket;

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Server _server;
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    MdnsService.stop().then((value) async {
      int port = await startService();
      await MdnsService.start('_pretty_logger._tcp', port);
    });
  }
  Future<int> startService() async {
    _server?.close();
    final streamServer = StreamServer();
    await streamServer.start(port: 0);
    _server = Server();
    _server.on('connect', (io) {
      Socket client = io;
      print('connect:${client.id} ${_remoteUrl(io)}');
      client.on('disconnect', (io) {
        print('disconnect:$io');
      });
      client.on('report', (data) {
        print('report:$data');
      });
      client.join(client.id);
    });
    _server.listen(streamServer);
    return _server.httpServer.channels[0].port;
  }

  String _remoteUrl(Socket io) {
    return '${io.request.connectionInfo.remoteAddress.address}:${io.request.connectionInfo.remotePort}';
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: false,
      child: Scaffold(
        body: Center(
            child: FlatButton(
          child: Text('none'),
          onPressed: () => {},
        )),
      ),
    );
  }
}
