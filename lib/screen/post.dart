import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;

enum PostType {
  normal,
  reply,
  quate;
}

class Post extends StatefulWidget {
  final PostType postType;
  final feed.Post? post;
  static Screen screen = Screen(Post, const Icon(Icons.edit));
  const Post({Key? key, this.postType = PostType.normal, this.post})
      : super(key: key);
  @override
  PostScreen createState() => PostScreen();
}

class PostScreen extends State<Post> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: padding(
      Form(
          key: _formKey,
          child: listsBody([
            operation(),
            const Divider(height: 0.5),
            form(context),
            const Divider(height: 0.5),
            media(),
          ])),
    ));
  }

  Widget operation() {
    return padding(Row(
      children: [
        InkWell(
          child: Text(tr("submit.cancel")),
          onTap: () {
            if (widget.postType == PostType.quate) {
              Navigator.pop(context);
            }
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _submit,
          child: Text(tr("submit.post")),
        )
      ],
    ));
  }

  Widget form(BuildContext context) {
    return padding(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // TODO user own avator
          children: [
            avator(context, plugin.api.session.actor!.avatar),
            Expanded(child: text())
          ],
        ),
        left: 0,
        top: 10,
        right: 0,
        bottom: 10);
  }

  Widget media() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          IconButton(
            tooltip: tr('media.photo'),
            icon: const Icon(Icons.photo_outlined),
            onPressed: () {},
          )
          // TODO camera
        ],
      ),
    );
  }

  Widget text({FormFieldValidator<String>? validator}) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: tr('post.placeholder'),
      ),
      onSaved: (text) {
        setState(() {
          _text = text!;
        });
      },
      validator: validator,
      minLines: 10,
      maxLines: 20,
      maxLength: 300,
    );
  }

  void _submit() async {
    _formKey.currentState?.save();
    debugPrint("_text: $_text");
    if (_text.isNotEmpty) {
      await plugin.post(_text);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
