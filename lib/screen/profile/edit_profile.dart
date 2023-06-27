// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/banner.dart' as prof;
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:tuple/tuple.dart';

class EditProfile extends StatefulWidget {
  static Screen screen = Screen(EditProfile, const Icon(Icons.edit));
  const EditProfile({Key? key}) : super(key: key);
  @override
  EditProfileScreen createState() => EditProfileScreen();
}

class EditProfileScreen extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late ProfileViewDetailed actor;

  String? displayName;
  String? description;
  // avatar
  bool isAvatarChanged = false;
  ImageFile? avatarFile;
  late Widget avatarWidget;
  // banner
  bool isBannerChanged = false;
  ImageFile? bannerFile;
  late Widget bannerWidget;

  void init() {
    actor = plugin.api.session.actor!;
    displayName = actor.displayName;
    description = actor.description;
    if (isAvatarChanged) {
      avatarWidget = avatarLink(Avatar(context).file(avatarFile!.bytes));
    } else {
      avatarWidget = avatarLink(Avatar(context).net(actor));
    }
    if (isBannerChanged) {
      bannerWidget = bannerLink(prof.Banner(context).file(bannerFile!.bytes));
    } else {
      bannerWidget = bannerLink(prof.Banner(context).net(actor));
    }
  }

  // get by file only for login account
  Widget avatarLink(Avatar holder) {
    return InkWell(
      child: holder.circleAvatar,
      onTap: () async {
        final result =
            await FilePicker.platform.pickFiles(type: FileType.media);
        if (result != null) {
          avatarFile = ImageFile(result.files[0]);
          isAvatarChanged = true;
          setState(() {});
        }
      },
    );
  }

  Widget bannerLink(prof.Banner holder) {
    return InkWell(
      child: holder.banner,
      onTap: () async {
        final result =
            await FilePicker.platform.pickFiles(type: FileType.media);
        if (result != null) {
          bannerFile = ImageFile(result.files[0]);
          isBannerChanged = true;
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: padding(
        Form(
            key: _formKey,
            child: SingleChildScrollView(child: listsBody(widgets))),
      ),
    );
  }

  List<Widget> get widgets {
    List<Widget> list = [
      padding(Row(children: [cancel, const Spacer(), submit])),
      const Divider(height: 0.5),
      padding(form, left: 0, top: 10, right: 0, bottom: 10)
    ];
    return list;
  }

  Widget get cancel {
    return InkWell(
      child: Text(tr("submit.cancel")),
      onTap: () {
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
        child: Text(tr("submit.save")));
  }

  Widget get form {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bannerAvatar,
        sizeBox,
        displayNameForm(),
        sizeBox,
        descriptionForm(),
      ],
    );
  }

  Widget get bannerAvatar {
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [bannerWidget, prof.Banner.blank]),
      avatarWidget
    ]);
  }

  Widget displayNameForm({FormFieldValidator<String>? validator}) {
    return TextFormField(
      decoration: decoration("profile.placeholder.displayName"),
      validator: validator,
      minLines: 1,
      maxLines: 2,
      maxLength: 640,
      initialValue: displayName,
      onSaved: (value) {
        setState(() {
          displayName = value!;
        });
      },
    );
  }

  Widget descriptionForm({FormFieldValidator<String>? validator}) {
    return TextFormField(
      decoration: decoration("profile.placeholder.description"),
      validator: validator,
      minLines: 10,
      maxLines: 20,
      maxLength: 2560,
      initialValue: description,
      onSaved: (value) {
        setState(() {
          description = value!;
        });
      },
    );
  }

  InputDecoration decoration(String prop) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: tr(prop),
    );
  }

  void _submit() async {
    _formKey.currentState?.save();
    Map? avatar = avatarFile != null ? await _upload(avatarFile!) : null;
    Map? banner = bannerFile != null ? await _upload(bannerFile!) : null;
    await plugin.updateProfile(
        displayName: displayName,
        description: description,
        avatar: avatar,
        banner: banner);
    reset();
    // reload profile page
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Base(selectedIndex: meIndex),
    ));
  }

  void reset() async {
    avatarFile = null;
    bannerFile = null;
    setState(() {});
  }

  Future<Map> _upload(ImageFile file) async {
    Tuple2 res = await plugin.uploadBlob(file.bytes, file.mineType!);
    return res.item2["blob"];
  }
}
