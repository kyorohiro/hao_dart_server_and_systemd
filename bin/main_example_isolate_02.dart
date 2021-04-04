import 'dart:isolate' as iso;

onMain(message) async {
  //
  print("child:arg:${message}");
  iso.SendPort sendPort = message['p'];
  for (var i = 0; i < 5; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    print("child:print:${i}");
    sendPort.send("hi${i}");
  }
}

main() async {
  iso.ReceivePort receivePort = iso.ReceivePort();
  receivePort.listen((message) {
    print("parent:onMessage: ${message}");
  });
  iso.Isolate.spawn(onMain, {"v": "Hi", "p": receivePort.sendPort});
  for (var i = 0; i < 5; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    print("parent:print:${i}");
  }

  receivePort.close();
}
