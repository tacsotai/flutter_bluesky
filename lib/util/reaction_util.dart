import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';

Widget withText(Reaction reaction, Function() func) {
  return Row(
    children: [
      button(reaction, func),
      Text(reaction.count.toString(), style: TextStyle(color: color(reaction)))
    ],
  );
}

Widget button(Reaction reaction, Function() func) {
  return IconTheme(
    data: IconThemeData(color: color(reaction)),
    child: Row(
      children: [
        IconButton(
          tooltip: reaction.tooltip,
          icon: reaction.uri != null ? reaction.on : reaction.off,
          onPressed: func,
        )
      ],
    ),
  );
}

Color color(Reaction reaction) {
  return reaction.uri != null ? reaction.color : Colors.grey;
}

// flutter/lib/src/material/popup_menu.dart#L1236
Future<void> popupMenu(BuildContext context, List<PopupMenuItem> items) async {
  final RenderBox button = context.findRenderObject()! as RenderBox;
  final RenderBox overlay =
      Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
  const Offset offset = Offset(0.0, 30.0);
  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    ),
    items: items,
    elevation: 8.0,
  );
}
