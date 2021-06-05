import 'dart:async';

import 'package:appscheme/appscheme.dart';

import 'plugin_controller.dart';

abstract class AppScheme {
  ///
  /// 获取第一次从外部打开的Scheme信息
  ///
  Future<SchemeEntity?> getInitScheme();

  ///
  /// 获取最新从外部打开的Scheme信息
  ///
  Future<SchemeEntity?> getLatestScheme();

  ///
  /// 注册从外部打开的Scheme监听信息
  ///
  Stream<SchemeEntity?> registerSchemeListener();
}

class AppSchemeImpl extends AppScheme {
  AppSchemeImpl._() : _schemeController = PluginControllerFactory().create();

  static AppSchemeImpl? _instance;

  static AppSchemeImpl? getInstance() {
    if (_instance == null) {
      _instance = AppSchemeImpl._();
    }
    return _instance;
  }

  SchemeController _schemeController;

  @override
  Future<SchemeEntity?> getInitScheme() async {
    return _schemeController.getInitScheme();
  }

  @override
  Future<SchemeEntity?> getLatestScheme() async {
    return _schemeController.getLatestScheme();
  }

  @override
  Stream<SchemeEntity?> registerSchemeListener() {
    return _schemeController.registerSchemeListener();
  }
}
