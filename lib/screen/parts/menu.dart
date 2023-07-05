import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/util/common_util.dart';

List<Menu> menus = [];
Widget? drawer = Drawer(
  child: ListView(
    shrinkWrap: true,
    children: menus,
  ),
);

class Menu extends StatelessWidget {
  final IconData icon;
  final String prop;
  final Widget? transfer;
  final String? link;
  final bool absorbing;

  const Menu({
    super.key,
    required this.icon,
    required this.prop,
    this.transfer,
    this.link,
    this.absorbing = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color =
        absorbing ? Colors.grey : Theme.of(context).colorScheme.primary;
    Widget text = padding(
      Text(
        tr(prop),
        style: TextStyle(fontSize: 18, color: color),
      ),
      left: 10,
      top: 0,
      bottom: 0,
      right: 0,
    );
    Widget widget = linkWidget(context, text, color);
    return absorbing
        ? AbsorbPointer(absorbing: absorbing, child: widget)
        : widget;
  }

  Widget linkWidget(BuildContext context, Widget text, Color color) {
    return InkWell(
        child: padding20(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            text,
          ],
        )),
        onTap: () async {
          inkwell(context, transfer: transfer, link: link);
        });
  }
}
