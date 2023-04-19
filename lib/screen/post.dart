import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:tuple/tuple.dart';

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
      body: lists(context),
    );
  }

  @override
  List<Widget> listview(BuildContext context, {Tuple2? res}) {
    return [submit(), sizeBox, form(), sizeBox, media()];
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
      children: [avatar(), sizeBox, Expanded(child: text())],
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

  Widget avatar() {
    // TODO network image
    return const CircleAvatar(
      // backgroundImage: NetworkImage(imgURL),
      // backgroundColor: ThemeColors.primary,
      child: Icon(Icons.person_outline_rounded),
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
    if (_text.isNotEmpty) {
      // Map note = screen.model;
      // screen.models[note['id']] = note;
      // note['owner'] = diaryTarget['owner'];
      // note['content'] = _text;
      // screen.save(note['id']);
      // home(context);
    }
  }
}
