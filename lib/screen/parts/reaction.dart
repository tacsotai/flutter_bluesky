import 'package:flutter/material.dart';

class Reaction {
  final Color color;
  final String tooltip;
  final Icon on;
  final Icon off;
  int count;
  String? uri;

  Reaction(
      {required this.color,
      required this.tooltip,
      required this.on,
      required this.off,
      required this.count,
      required this.uri});

  Reaction get renew {
    return Reaction(
        color: color,
        tooltip: tooltip,
        on: on,
        off: off,
        count: count,
        uri: uri);
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
    // The notifyListeners notify at chnage the value object.
    value = value.renew;
  }
}
