import 'dart:io' as io;

void main(List<String> arguments) async {
  try {
    print("start bind");
    var httpServer = await io.HttpServer.bind("0.0.0.0", 80);
    print("binded");
    await for (var request in httpServer) {
      print("receive requested ${request.uri}");
      request.response.write("Hello");
      request.response.close();
    }
  } catch (e, s) {
    print("${e}");
    print("${s}");
  }
}
