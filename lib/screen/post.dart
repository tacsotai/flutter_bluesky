import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class Post extends StatefulWidget {
  static Screen screen = Screen(Post, const Icon(Icons.edit));
  const Post({Key? key}) : super(key: key);
  @override
  PostScreen createState() => PostScreen();
}

class PostScreen extends State<Post> with Base {
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
          onTap: () => {Navigator.pop(context)},
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
