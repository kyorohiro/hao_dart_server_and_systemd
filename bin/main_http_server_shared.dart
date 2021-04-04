import 'dart:io' as io;
import 'dart:isolate' as iso;

onIsolateMain(message) async {
  var server = await io.HttpServer.bind("0.0.0.0", 8080, shared: true);
  await for (var request in server) {
    print("${request.uri}");
    request.response.write("${message}");
    request.response.close();
  }
}

main() async {
  var server = await io.HttpServer.bind("0.0.0.0", 8080, shared: true);
  server.listen((request) {
    print("${request.uri}");
    request.response.write("parent");
    request.response.close();
  });
  //
  for (int i = 0; i < 10; i++) {
    iso.Isolate.spawn(onIsolateMain, "${i}");
  }
}
