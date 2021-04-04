import 'dart:isolate' as iso;

void onSpwanChildIsolateMain(message) async {
  String v = message["v"];
  iso.SendPort portToParent = message["p"];

  //
  // create connection child and parent.
  var receivePortFromParent = iso.ReceivePort();
  receivePortFromParent.listen((message) {
    print("child:onMessage: ${message}");
  });
  portToParent.send({"t": "p", "v": receivePortFromParent.sendPort});

  //
  // send messgea to parent
  for (var i = 0; i < 10; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    portToParent.send({"t": "m", "v": "[${i}] ${v}"});
  }

  return;
}

void main() async {
  //
  // prepare creating connection to child
  var receivePortFromChild = iso.ReceivePort();
  var receivePortFromChildOnError = iso.ReceivePort();
  var receivePortFromChildOnExit = iso.ReceivePort();

  iso.SendPort portToChild0;
  receivePortFromChild.listen((message) {
    print("parent:onMessage: ${message}");
    if (message == null) {
      return;
    }
    if (message["t"] == "p") {
      // connection from child
      print("parent:GetPort");
      portToChild0 = message["v"];
      portToChild0.send("Hi Child0");
    } else if (message["t"] == "m") {
      // receive message
      print("parent:GetMessage ${message['v']}");
      print("message: ${message}");
    }
  });
  receivePortFromChildOnError.listen((message) {
    print("error: ${message}");
  });
  receivePortFromChildOnExit.listen((message) {
    print("exit: ${message}");
  });

  var child0Isolate = await iso.Isolate.spawn(
    onSpwanChildIsolateMain,
    {"v": "Zero", "p": receivePortFromChild.sendPort},
    onError: receivePortFromChildOnError.sendPort,
    onExit: receivePortFromChildOnExit.sendPort,
  );

  ///
  /// pause / resume sample
  ///
  var puaseCapability = iso.Capability();
  for (var i = 0; i < 20; i++) {
    await Future.delayed(Duration(milliseconds: 200));
    if (i % 2 == 0) {
      child0Isolate.pause(puaseCapability);
    } else {
      if (puaseCapability != null) {
        child0Isolate.resume(puaseCapability);
      }
    }
  }

  //child0Isolate.kill();
  //iso.Isolate.current.kill();
  receivePortFromChild.close();
  receivePortFromChildOnError.close();
  receivePortFromChildOnExit.close();
}
