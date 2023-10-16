import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class EmbedUtil {
  static Widget arrange(List<EmbedImage> imgs) {
    if (imgs.length == 1) {
      return Row(children: [Expanded(child: imgs[0])]);
    } else if (imgs.length == 2) {
      return Row(
          children: [Expanded(child: imgs[0]), Expanded(child: imgs[1])]);
    } else if (imgs.length == 3) {
      return Row(children: [
        Flexible(flex: 2, child: Column(children: [imgs[0]])),
        Flexible(flex: 1, child: Column(children: [imgs[1], imgs[2]])),
      ]);
    } else if (imgs.length == 4) {
      return Row(children: [
        Expanded(child: Column(children: [imgs[0], imgs[1]])),
        Expanded(child: Column(children: [imgs[2], imgs[3]])),
      ]);
    } else {
      // TODO over 5
      throw Exception("embed.type images length: ${imgs.length}");
    }
  }
}

class EmbedImage extends StatelessWidget {
  final Images images;
  const EmbedImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Image.network(images.thumb);
  }

  static List<EmbedImage> widgets(List<Images> imagesList) {
    List<EmbedImage> embedImages = [];
    for (Images images in imagesList) {
      embedImages.add(EmbedImage(images: images));
    }
    return embedImages;
  }
}
