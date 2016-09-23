import 'dart:io';

main() {
  HttpServer
      .bind(InternetAddress.ANY_IP_V6, 80)
      .then((server) {
        server.listen((HttpRequest request) {
          request.response.write('Hello, world!');
          request.response.close();
        });
      });
}