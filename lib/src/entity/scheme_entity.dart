import 'package:flutter/material.dart';

class SchemeEntity {
  final String? scheme;
  final String? host;
  final int? port;
  final String? path;
  final Map<String, String>? query;
  final String? source;
  final String? dataString;
  SchemeEntity({
    required this.scheme,
    this.host,
    this.port,
    this.path,
    this.query,
    this.source,
    required this.dataString,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheme': this.scheme,
      'host': this.host,
      'port': this.port,
      'path': this.path,
      'query': this.query,
      'source': this.source,
      'dataString': this.dataString
    };
  }
}
