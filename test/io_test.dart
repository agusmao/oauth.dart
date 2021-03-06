import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:oauth/oauth.dart' as oauth;
import 'package:oauth/server_io.dart';
import '_server.dart';

main() {
  HttpServer server;
  setUp(() {
    return HttpServer.bind(InternetAddress.loopbackIPv6, 8989).then((server_) {
      server = server_;
      server.listen((HttpRequest request) {
        var reqAdapter = new HttpRequestAdapter(request);
        oauth.isAuthorized(reqAdapter, simpleTokenFinder, simpleNonceQuery)
            .then((bool authorized) {
          request.response.statusCode = authorized ? HttpStatus.ok : HttpStatus.forbidden;
          request.response.write("Body");
          return request.response.close();
        });
      });
    });
  });
  tearDown(() {
    return server.close(force: false).then((_) {
      return new Future.delayed(new Duration(milliseconds: 100));
    });
  });
  
  runAllTests("localhost:8989");
}