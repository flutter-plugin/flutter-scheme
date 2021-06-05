class SchemeEntity {
  String scheme;
  String host;
  int port;
  String path;
  Map<String, String> query;
  String source;
  String dataString;
  SchemeEntity({
    this.scheme,
    this.host,
    this.port,
    this.path,
    this.query,
    this.source,
    this.dataString,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheme': scheme,
      'host': host,
      'port': port,
      'path': path,
      'query': query,
      'source': source,
      'dataString': dataString
    };
  }
}
