// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/image/banner.dart' as prof;
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/screen/parts/image/picture.dart';
import 'package:flutter_bluesky/screen/profile/profile_updater.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/image_util.dart';

class EditProfile extends StatefulWidget {
  static Screen screen = Screen(EditProfile, const Icon(Icons.edit));
  const EditProfile({Key? key}) : super(key: key);
  @override
  EditProfileScreen createState() => EditProfileScreen();
}

class EditProfileScreen extends State<EditProfile> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isInit = true;
  late ProfileViewDetailed actor;

  String? displayName;
  String? description;
  Avatar? avatar;
  prof.Banner? banner;

  void init() {
    displayName = actor.displayName;
    description = actor.description;
    avatar = Avatar(context).net(actor);
    banner = prof.Banner(context).net(actor);
  }

  Widget link(Picture picture) {
    return InkWell(
      child: picture.widget,
      onTap: () async {
        final result = await ImageUtil.pickImage();
        if (result != null) {
          picture.setImage(ImageFile(result));
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    checkSession(context);
    actor = plugin.api.session.actor!;
    if (isInit) {
      init();
      isInit = false;
    }
    return Scaffold(
      body: padding10(
        Form(
            key: formKey,
            child: SingleChildScrollView(child: listsBody(widgets))),
      ),
    );
  }

  List<Widget> get widgets {
    List<Widget> list = [
      padding10(Row(children: [cancel, const Spacer(), submit])),
      const Divider(height: 0.5),
      padding10(form, left: 0, top: 10, right: 0, bottom: 10)
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
        onPressed: submitData,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
        child: Text(tr(submitProp())));
  }

  String submitProp() {
    return "submit.save";
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
          children: [link(banner!), prof.Banner.blank]),
      link(avatar!)
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

  Future<void> submitData() async {
    formKey.currentState?.save();
    await ProfileUpdater(plugin, displayName, description, avatar, banner)
        .save();
    setState(() {});
    // reload profile page
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Base(selectedIndex: meIndex),
    ));
  }
}
