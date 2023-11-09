import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/report_util.dart';

class AccountReport extends StatefulWidget {
  final ProfileViewDetailed actor;
  const AccountReport({super.key, required this.actor});

  @override
  AccountReportScreen createState() => AccountReportScreen();
}

class AccountReportScreen extends State<AccountReport> {
  final GlobalKey<FormState> formKey = GlobalKey();
  ModalButton? button;
  ReasonType? selected;
  String? reason;

  Widget header = padding20(
      Text(tr("report.account"), style: const TextStyle(fontSize: 24)));
  Widget content = Text(tr("report.account.message"),
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
      tile(ReasonType.reasonMisleading),
      tile(ReasonType.reasonSpam),
      tile(ReasonType.reasonViolation),
      reasonForm(),
    ];
    if (selected != null) {
      button = accountReportButton(this, widget.actor, selected!, reason);
      list.add(button!.widget);
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
          Text(tr("report.account.${reasonType.name}")),
          Text(
            tr("report.account.${reasonType.name}.description"),
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

ReportButton accountReportButton(State state, ProfileViewDetailed actor,
    ReasonType reasonType, String? reason) {
  Map<String, dynamic> subject = {
    "\$type": "com.atproto.admin.defs#repoRef",
    "did": actor.did
  };
  return reportButton(state, subject, reasonType, reason);
}
