// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:path/path.dart' as path;
import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

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
  List<PlatformFile> files = [];
  List<Widget> selects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: padding(
        Form(
            key: _formKey,
            child: SingleChildScrollView(child: listsBody(widgets))),
      ),
      bottomNavigationBar: BottomAppBar(child: media()),
    );
  }

  List<Widget> get widgets {
    List<Widget> list = [
      padding(Row(children: [cancel, const Spacer(), submit])),
      const Divider(height: 0.5),
      form(context),
      SizedBox(height: 350, child: Row(children: selects))
    ];
    if (widget.postType == PostType.reply) {
      list.insertAll(2, replyPost(context, widget.post!));
    }
    if (widget.postType == PostType.quate) {
      list.addAll(quatePost(context, widget.post!));
    }
    return list;
  }

  Widget get cancel {
    return InkWell(
      child: Text(tr("submit.cancel")),
      onTap: () {
        if (widget.postType == PostType.quate) {
          Navigator.pop(context);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget get submit {
    return ElevatedButton(
        onPressed: _submit,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
        child: Text(tr("submit.post.${widget.postType.name}")));
  }

  Widget form(BuildContext context) {
    return padding(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: tr('media.photo'),
            icon: const Icon(Icons.photo_outlined),
            onPressed: _pickFile,
          )
          // TODO camera with BottomNavigationBarItem
        ],
      ),
    );
  }

  // up to 4 files to select
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ImageUtil.exts.keys.toList());
    if (result != null) {
      if (result.files.length > 4) {
        files = result.files.sublist(0, 4);
      } else {
        files = result.files;
      }
      _selects();
    }
  }

  void _selects() {
    selects.clear();
    for (PlatformFile file in files) {
      selects.add(Expanded(
          child: Stack(children: [Image.memory(file.bytes!), _close(file)])));
    }
    setState(() {});
  }

  Widget _close(PlatformFile file) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      fillColor: Colors.white10,
      shape: const CircleBorder(),
      onPressed: () {
        files.remove(file);
        _selects();
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
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
      minLines: 1,
      maxLines: 10,
      maxLength: 300,
    );
  }

  void _submit() async {
    _formKey.currentState?.save();
    List<Map>? images = [];
    for (var file in files) {
      Tuple2 res = await plugin.uploadBlob(file.bytes!, _contentType(file)!);
      images.add({"image": res.item2["blob"], "alt": ""});
    }
    if (images.isEmpty) {
      images = null;
    }
    await plugin.post(_text, images: images);
    Navigator.pop(context);
  }

  String? _contentType(PlatformFile file) {
    String fileName = path.basename(file.name);
    String extension = path.extension(fileName);
    return ImageUtil.exts[extension.substring(1)];
  }
}

List<Widget> replyPost(BuildContext context, feed.Post post) {
  return [
    padding(
        paddingLR([
          avator(context, post.author.avatar)
        ], [
          Header(author: post.author, createdAt: post.record.createdAt),
          Body(post: post),
        ]),
        left: 0,
        right: 0),
    const Divider(height: 0.5),
  ];
}

List<Widget> quatePost(BuildContext context, feed.Post post) {
  return [
    Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: paddingLR([
          avator(context, post.author.avatar)
        ], [
          Header(author: post.author, createdAt: post.record.createdAt),
          Body(post: post),
        ]))
  ];
}
