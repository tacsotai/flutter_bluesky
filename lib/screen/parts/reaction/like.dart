import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

class Like extends StatelessWidget {
  final Post post;
  const Like(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.pink,
        tooltip: tr("reaction.like"),
        on: const Icon(Icons.favorite),
        off: const Icon(Icons.favorite_outline),
        count: post.likeCount,
        uri: post.viewer.like);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const LikeWidget(),
      create: (context) => LikeState(reaction, context, post),
    );
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
class LikeState extends ValueNotifier<Reaction> {
  final BuildContext context;
  final Post post;
  LikeState(Reaction value, this.context, this.post) : super(value);

  void action() async {
    if (value.uri != null) {
      value.count -= 1;
      // unlike
      plugin.unlike(post.viewer.like!);
    } else {
      value.count += 1;
      // like
      // plugin.createRecord(repo, collection, record);
      // value.uri = !value.uri;
    }

    // The notifyListeners notify at chnage the value object.
    value = value.renew;
  }
}

class LikeWidget extends AcceptableStatefulWidget {
  const LikeWidget({Key? key}) : super(key: key);

  @override
  LikeScreen createState() => LikeScreen();
}

class LikeScreen extends AcceptableStatefulWidgetState<LikeWidget> {
  late Reaction reaction;

  @override
  void acceptProviders(Accept accept) {
    accept<LikeState, Reaction>(
      watch: (state) => state.value,
      apply: (value) => reaction = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return withText(reaction, context.read<LikeState>().action);
  }
}
