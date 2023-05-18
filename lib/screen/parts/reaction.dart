import 'package:flutter/material.dart';

class Reaction {
  final Color color;
  final String tooltip;
  final Icon on;
  final Icon off;
  int count;
  bool own;

  Reaction(
      {required this.color,
      required this.tooltip,
      required this.on,
      required this.off,
      required this.count,
      required this.own});

  Reaction get renew {
    return Reaction(
        color: color,
        tooltip: tooltip,
        on: on,
        off: off,
        count: count,
        own: own);
  }
}

/// [ValueNotifier]
/// set value(T newValue) {
///   if (_value == newValue) {
///     return;
///   }
///   _value = newValue;
///   notifyListeners();
/// }
class ReactionState extends ValueNotifier<Reaction> {
  ReactionState(Reaction value) : super(value);

  void action() {
    if (value.own) {
      value.count -= 1;
    } else {
      value.count += 1;
    }
    value.own = !value.own;
    // The notifyListeners notify at chnage the value object.
    value = value.renew;
  }
}

Widget widget(BuildContext context, Reaction reaction) {
  Color color = reaction.own ? reaction.body.color : Colors.grey;
  Widget icon = iconTheme(context, reaction, color);
  if (reaction.withCount) {
    return Row(
      children: [
        icon,
        Text(
          reaction.count.toString(),
          style: TextStyle(color: color),
        )
      ],
    );
  } else {
    return icon;
  }
}

Widget iconTheme(BuildContext context, Reaction reaction, Color color) {
  Icon icon = reaction.own ? reaction.body.on : reaction.body.off;
  return IconTheme(
    data: IconThemeData(color: color),
    child: Row(
      children: [
        IconButton(
          tooltip: reaction.body.tooltip,
          icon: icon,
          onPressed: context.read<ReactionState>().action,
        )
      ],
    ),
  );
}
