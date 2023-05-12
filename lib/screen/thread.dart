import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_post.dart';
import 'package:tuple/tuple.dart';

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
      body: _build(),
    );
  }

  // parent?
  // post
  // replis?
  Widget body(ThreadResponse res) {
    List<Widget> widgets = [];
    if (res.thread.parentMap != null) {
      widgets.add(postLineFrame(context, res.thread.parent.post));
    }
    widgets.add(postLineFrame(context, res.thread.post, isMain: true));
    if (res.thread.replyList != null) {
      for (var reply in res.thread.replies) {
        widgets.add(postLineFrame(context, reply.post));
      }
    }
    return SingleChildScrollView(child: Column(children: widgets));
  }

  Widget _build() {
    return FutureBuilder(
        future: getData(widget.handle!, widget.uri!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return body(snapshot.data);
          }
        });
  }

  Future<ThreadResponse> getData(String handle, String uri) async {
    late ThreadResponse response;
    try {
      Tuple2 check = await plugin.resolveHandle(handle);
      if (check.item1 != 200) {
        throw Exception(check.item2);
      }
      Tuple2 res = await plugin.getPostThread(uri);
      response = ThreadResponse(res.item2);
    } catch (e, stacktrace) {
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
    return response;
  }
}
