import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Thread extends StatefulWidget {
  static Screen screen = Screen(Thread, const Icon(Icons.edit));
  const Thread({Key? key, this.handle, this.uri}) : super(key: key);
  final String? handle;
  final String? uri;
  @override
  ThreadScreen createState() => ThreadScreen();
}

class ThreadScreen extends State<Thread> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(children: [
      Text("screen: ${Thread.screen.name}"),
      Text("handle: ${widget.handle}"),
      Text("uri: ${widget.uri}"),
    ]);
  }
}
