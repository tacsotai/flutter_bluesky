import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';

class PostDelete extends StatefulWidget {
  final Post post;
  const PostDelete({super.key, required this.post});

  @override
  PostDeleteScreen createState() => PostDeleteScreen();
}

class PostDeleteScreen extends State<PostDelete> {
  Widget header = padding20(
      Text(tr("delete.post.header"), style: const TextStyle(fontSize: 24)));
  Widget content = Text(tr("delete.post.message"),
      style: const TextStyle(color: Colors.black87));

  @override
  Widget build(BuildContext context) {
    ModalButton button = PostDeleteConfirmButton(this, widget.post);
    return Column(
        children: [header, content, sizeBox, sizeBox, sizeBox, button.widget]);
  }
}

class PostDeleteConfirmButton extends ConfirmButton {
  final Post post;

  PostDeleteConfirmButton(super.state, this.post);

  @override
  Future<void> action() async {
    await plugin.delete(post.uri);
    // ignore: use_build_context_synchronously
    Navigator.of(state.context).pushReplacement(MaterialPageRoute(
      builder: (context) => Base(),
    ));
  }
}
