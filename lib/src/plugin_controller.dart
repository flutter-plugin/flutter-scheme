import 'package:flutter/services.dart';
import 'entity/scheme_entity.dart';

abstract class SchemeController {
  Future<SchemeEntity?> getInitScheme();
  Future<SchemeEntity?> getLatestScheme();
  Stream<SchemeEntity?> registerSchemeListener();
}

class PluginController implements SchemeController {
  final MethodChannel _schemeChannel;
  final EventChannel _eventChannel;

  PluginController(
      {required MethodChannel schemeChannel,
      required EventChannel eventChannel})
      : _schemeChannel = schemeChannel,
        _eventChannel = eventChannel;

  @override
  Future<SchemeEntity?> getInitScheme() async {
    dynamic data = await _schemeChannel.invokeMethod('getInitScheme');
    if (data != null && data is Map && data.isNotEmpty) {
      return SchemeEntity(
        scheme: data['scheme'] as String?,
        host: data['host'] as String?,
        port: data['port'] as int?,
        path: data['path'] as String?,
        query: Uri.parse(data['dataString'] as String).queryParameters,
        source: data['source'] as String?,
        dataString: data['dataString'] as String?,
      );
    }
    return null;
  }

  @override
  Future<SchemeEntity?> getLatestScheme() async {
    dynamic data = await _schemeChannel.invokeMethod('getLatestScheme');
    if (data != null && data is Map && data.isNotEmpty) {
      Map<String, String> queryParameters =
          Uri.parse(data['dataString'] as String).queryParameters;

      return SchemeEntity(
        scheme: data['scheme'] as String?,
        host: data['host'] as String?,
        port: data['port'] as int?,
        path: data['path'] as String?,
        query: queryParameters,
        source: data['source'] as String?,
        dataString: data['dataString'] as String?,
      );
    }
    return null;
  }

  @override
  Stream<SchemeEntity?> registerSchemeListener() {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => event)
        .asBroadcastStream()
        .map((event) => (event != null && event is Map && event.isNotEmpty)
            ? SchemeEntity(
                scheme: event['scheme'] as String?,
                host: event['host'] as String?,
                port: event['port'] as int?,
                path: event['path'] as String?,
                query: Uri.parse(event['dataString'] as String).queryParameters,
                source: event['source'] as String?,
                dataString: event['dataString'] as String?,
              )
            : null);
  }
}

class PluginControllerFactory {
  const PluginControllerFactory();
  PluginController create() {
    const MethodChannel _channelMethod =
        const MethodChannel('scheme/flutter.app.method');
    const EventChannel _eventChannel =
        const EventChannel('scheme/flutter.app.event');
    PluginController _controller = PluginController(
        schemeChannel: _channelMethod, eventChannel: _eventChannel);
    return _controller;
  }
}
