import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
import 'package:flutter_bluesky/api/model/embed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/util/post_util.dart';

const double mediaHeight = 350;

enum PostType {
  normal,
  reply,
  quote;
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

  Map<String, dynamic>? record;
  double _height = 0;
  String _text = "";
  List<XFile> files = [];
  List<Widget> selects = [];

  @override
  Widget build(BuildContext context) {
    checkSession(context);
    return Scaffold(
      body: padding10(
        Form(
            key: _formKey,
            child: SingleChildScrollView(child: listsBody(widgets))),
      ),
      bottomNavigationBar: BottomAppBar(child: media()),
    );
  }

  List<Widget> get widgets {
    List<Widget> list = [
      padding10(Row(children: [cancel, const Spacer(), submit])),
      const Divider(height: 0.5),
      form(context),
      SizedBox(height: _height, child: Row(children: selects))
    ];
    if (widget.postType == PostType.reply) {
      record = reply;
      list.insertAll(2, replyPost(context, widget.post!));
    }
    if (widget.postType == PostType.quote) {
      record = quote;
      list.addAll(quotePost(context, widget.post!));
    }
    return list;
  }

  Widget get cancel {
    return InkWell(
      child: Text(tr("submit.cancel")),
      onTap: () {
        if (widget.postType == PostType.quote) {
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
    return padding10(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(context).net(plugin.api.session.actor!).profile,
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
    final result = await ImageUtil.pickMultiImage();
    if (result.length > 4) {
      files = result.sublist(0, 4);
    } else {
      files = result;
    }
    _selects();
  }

  void _selects() {
    selects.clear();
    for (XFile file in files) {
      selects.add(Expanded(
          child: Stack(children: [ImageUtil.image(file), _close(file)])));
    }
    files.isEmpty ? _height = 0 : _height = mediaHeight;
    setState(() {});
  }

  Widget _close(XFile file) {
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
      decoration: decoration('post.placeholder.${widget.postType.name}'),
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
    PostUtil.post(_text, context, record: record, files: files);
    Navigator.pop(context);
  }

  // "root": {
  //   "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //   "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  // },
  // "parent": {
  //   "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //   "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  // }
  Map<String, dynamic>? get reply {
    String uri = widget.post!.uri;
    String cid = widget.post!.cid;
    Map<String, dynamic>? root = {"uri": uri, "cid": cid};
    Map<String, dynamic>? parent = {"uri": uri, "cid": cid};
    RecordReply? recordReply = widget.post!.record.reply;
    if (recordReply != null) {
      root = recordReply.root;
    }
    return {
      "reply": {"root": root, "parent": parent}
    };
  }

  // "embed": {
  //   "$type": "app.bsky.embed.record",
  //   "record": {
  //     "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //     "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  //   }
  // }
  Map<String, dynamic>? get quote {
    return {
      "embed": {
        "\$type": "app.bsky.embed.record",
        "record": {"uri": widget.post!.uri, "cid": widget.post!.cid}
      }
    };
  }
}

List<Widget> replyPost(BuildContext context, feed.Post post) {
  return [
    padding10(
        paddingLR([
          Avatar(context).net(post.author).profile
        ], [
          Header(author: post.author, createdAt: post.record.createdAt),
          Body(post: post),
        ]),
        left: 0,
        right: 0),
    const Divider(height: 0.5),
  ];
}

List<Widget> quotePost(BuildContext context, feed.Post post) {
  return [
    embedBox(paddingLR([
      Avatar(context).net(post.author).profile
    ], [
      Header(author: post.author, createdAt: post.record.createdAt),
      Body(post: post),
    ]))
  ];
}
