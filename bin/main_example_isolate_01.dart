import 'dart:isolate' as iso;

onMain(message) async {
  //
  print("child:arg:${message}");
  for (var i = 0; i < 5; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    print("child:print:${i}");
  }
}

main() async {
  iso.Isolate.spawn(onMain, "Hi");
  for (var i = 0; i < 5; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    print("parent:print:${i}");
  }
}
