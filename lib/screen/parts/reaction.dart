import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ReactionBody {
  final Color color;
  final String tooltip;
  final Icon on;
  final Icon off;

  ReactionBody(
      {required this.color,
      required this.tooltip,
      required this.on,
      required this.off});
}

class Reaction {
  final ReactionBody body;
  final bool withCount;
  int count;
  bool own;

  Reaction(
      {required this.body,
      required this.withCount,
      required this.count,
      required this.own});

  Reaction get renew {
    return Reaction(body: body, withCount: withCount, count: count, own: own);
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
