import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class MdnsService {
  static const MethodChannel _channel = const MethodChannel('pretty_logger_client/mdns_service');

  static Future<void> start(String type, int port, {String domain = '', String name = ''}) async {
    final res = await _channel.invokeMethod(
      'start',
      {
        'domain': domain,
        'type': type,
        'name': name,
        'port': port,
      },
    );
    if (null != res && '' == res) {
      throw Exception(res);
    }
  }

  static Future<void> setTxtRecord(Map<String, Uint8List> txtRecord) async {
    final res = await _channel.invokeMethod(
      'setTxtRecord',
      {
        'txtRecord': txtRecord,
      },
    );
    if (null != res && '' == res) {
      throw Exception(res);
    }
  }

  static Future<void> stop() async {
    final res = await _channel.invokeMethod(
      'stop',
    );
    if (null != res && '' == res) {
      throw Exception(res);
    }
  }
}
