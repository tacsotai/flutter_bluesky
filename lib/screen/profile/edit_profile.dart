// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:path/path.dart' as path;
import 'package:tuple/tuple.dart';

const double mediaHeight = 350;

// プロフとボットの両方　。。。　タイトルのみでどうにかする。
class EditProfile extends StatefulWidget {
  static Screen screen = Screen(EditProfile, const Icon(Icons.edit));
  const EditProfile({Key? key}) : super(key: key);
  @override
  EditProfileScreen createState() => EditProfileScreen();
}

class EditProfileScreen extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String displayName = "";
  String description = "";
  late PlatformFile file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: padding(
        Form(
            key: _formKey,
            child: SingleChildScrollView(child: listsBody(widgets))),
      ),
    );
  }

  List<Widget> get widgets {
    List<Widget> list = [form(context), submit, cancel];
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

  Widget form(BuildContext context) {
    return padding(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avator(context, plugin.api.session.actor!.avatar),
          ],
        ),
        left: 0,
        top: 10,
        right: 0,
        bottom: 10);
  }

  Widget textFormField(
      {required String prop,
      int? minLines,
      int? maxLines,
      int? maxLength,
      FormFieldValidator<String>? validator}) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: tr(prop),
      ),
      onSaved: (value) {
        setText(prop, value);
      },
      validator: validator,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 10,
      maxLength: maxLength ?? 300,
    );
  }

  void setText(String prop, String? value) {
    setState(() {
      if (prop == "profile.placeholder.displayName") {
        displayName = value!;
      }
      if (prop == "profile.placeholder.description") {
        description = value!;
      }
    });
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files[0];
    }
  }

  void _submit() async {
    _formKey.currentState?.save();
    List<Map>? images = [];

    await plugin.put(displayName, images: images, record: record);
    Navigator.pop(context);
  }

  String? _contentType(PlatformFile file) {
    String fileName = path.basename(file.name);
    String extension = path.extension(fileName);
    return ImageUtil.exts[extension.substring(1)];
  }
}
