import 'dart:io' as io;

const String cerbotWebRootPath = "/var/www/html";

void main(List<String> arguments) async {
  try {
    print("start bind");
    var httpServer = await io.HttpServer.bind("0.0.0.0", 80);
    print("binded");
    await for (var request in httpServer) {
      print("receive requested ${request.uri}");
      if (request.uri.path.startsWith("/.well-known/")) {
        var acmeChallengeFilePath = "" +
            cerbotWebRootPath +
            request.uri.path.replaceAll(RegExp("\\?.*"), "");
        acmeChallengeFilePath = acmeChallengeFilePath.replaceAll("/..", "/");
        var acmeChallengeFile = io.File(acmeChallengeFilePath);
        var acmeChallengeData = await acmeChallengeFile.readAsString();
        request.response.write(acmeChallengeData);
        request.response.close();
      }
      request.response.write("Hello");
      request.response.close();
    }
  } catch (e, s) {
    print("${e}");
    print("${s}");
  }
}
