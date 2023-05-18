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
