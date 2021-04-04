import 'dart:io' as io;

const String cerbotWebRootPath = "/var/www/html";
const String privkeyPath = "/etc/letsencrypt/live/tetorica.net/privkey.pem";
const String fullchainPath = "/etc/letsencrypt/live/tetorica.net/fullchain.pem";
void main(List<String> arguments) async {
  try {
    print("start bind");
    onRequest(io.HttpRequest request) async {
      try {
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
      } catch (e, s) {
        print("${e}");
        print("${s}");
      }
    }

    var httpServer = await io.HttpServer.bind("0.0.0.0", 8080);
    print("binded 80");
    httpServer.listen((request) {
      onRequest(request);
    });

    String key = io.Platform.script.resolve(privkeyPath).toFilePath();
    String crt = io.Platform.script.resolve(fullchainPath).toFilePath();
    io.SecurityContext context = new io.SecurityContext();
    context.useCertificateChain(crt);
    context.usePrivateKey(key, password: "");
    var httpsServer = await io.HttpServer.bindSecure("0.0.0.0", 8443, context);
    httpsServer.listen((request) {
      onRequest(request);
    });
  } catch (e, s) {
    print("${e}");
    print("${s}");
  }
}
