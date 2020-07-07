import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class MdnsService {
  static const MethodChannel _channel = const MethodChannel('pretty_logger_client/mdns_service');

  static Future<String> start(String type, int port, {String domain = '', String name = ''}) async {
    return (await _channel.invokeMethod(
      'start',
      {
        'domain': domain,
        'type': type,
        'name': name,
        'port': port,
      },
    )) as String;
  }

  static Future<String> setTxtRecord(Map<String, Uint8List> txtRecord) async {
    return (await _channel.invokeMethod(
      'setTxtRecord',
      {
        'txtRecord': txtRecord,
      },
    )) as String;
  }

  static Future<String> stop() async {
    return (await _channel.invokeMethod(
      'stop',
    )) as String;
  }
}
