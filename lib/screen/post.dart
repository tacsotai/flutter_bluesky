import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      body: Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: listsBody([submit(), sizeBox, form(), sizeBox, media()]),
          )),
    );
  }

  Widget submit() {
    return Row(
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
    );
  }

  Widget form() {
    return Row(
      // TODO user own avator
      children: [avator(null), sizeBox, Expanded(child: text())],
    );
  }

  Widget media() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Photo',
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

  void _submit() {
    _formKey.currentState?.save();
    if (_text.isNotEmpty) {}
  }
}
