import 'package:flutter/services.dart';

class Share {
  final MethodChannel _channel = const MethodChannel('flutter_vesti_share');
  final Map<String, Object?> arguments = Map<String, dynamic>();
  dynamic result;
  Future<String?> whatsAppImageList({List? paths, bool? business}) async {
    arguments.putIfAbsent('paths', () => paths);
    arguments.putIfAbsent('business', () => business);
    try {
      result = await _channel.invokeMethod('whatsAppImageList', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  Future<String?> whatsAppText(
      {String msg = '',
      String phone = '',
      bool? business = false,
      bool? useCallShareCenter = false}) async {
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('phone', () => phone);
    arguments.putIfAbsent('business', () => business);
    arguments.putIfAbsent('useCallShareCenter', () => useCallShareCenter);
    try {
      result = await _channel.invokeMethod('whatsAppText', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }
}
