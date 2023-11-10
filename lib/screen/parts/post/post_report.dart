import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/report_util.dart';

// ignore: must_be_immutable
class PostReport extends StatefulWidget {
  final Post post;
  late ModalButton button;
  PostReport({super.key, required this.post});

  @override
  PostReportScreen createState() => PostReportScreen();
}

class PostReportScreen extends State<PostReport> {
  final GlobalKey<FormState> formKey = GlobalKey();
  ReasonType? selected;
  String? reason;

  Widget header =
      padding20(Text(tr("report.post"), style: const TextStyle(fontSize: 24)));
  Widget content = Text(tr("report.post.message"),
      style: const TextStyle(color: Colors.black87));

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: SingleChildScrollView(child: Column(children: widgets)));
  }

  List<Widget> get widgets {
    List<Widget> list = [
      header,
      content,
      tile(ReasonType.reasonSpam),
      tile(ReasonType.reasonSexual),
      tile(ReasonType.reasonRude),
      tile(ReasonType.reasonViolation),
      tile(ReasonType.reasonOther),
      reasonForm(),
    ];
    if (selected != null) {
      widget.button = postReportButton(this, widget.post, selected!, reason);
      list.add(widget.button.widget);
    }
    return list;
  }

  Widget reasonForm({FormFieldValidator<String>? validator}) {
    return padding(
        TextFormField(
          decoration: decoration("report.reason"),
          validator: validator,
          minLines: 3,
          maxLines: 8,
          maxLength: 300,
          initialValue: reason,
          onSaved: (value) {
            setState(() {
              reason = value!;
            });
          },
        ),
        left: 20,
        top: 0,
        right: 20,
        bottom: 0);
  }

  RadioListTile tile(ReasonType reasonType) {
    return RadioListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr("report.post.${reasonType.name}")),
          Text(
            tr("report.post.${reasonType.name}.description"),
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
      value: reasonType,
      groupValue: selected,
      onChanged: (value) => _onSelected(value),
    );
  }

  _onSelected(ReasonType reasonType) {
    setState(() {
      selected = reasonType;
    });
  }
}

ReportButton postReportButton(
    State state, Post post, ReasonType reasonType, String? reason) {
  Map<String, dynamic> subject = {
    "\$type": "com.atproto.repo.strongRef",
    "uri": post.uri,
    "cid": post.cid
  };
  return reportButton(state, subject, reasonType, reason);
}
