import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/embed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

class EmbedUtil {
  static Widget arrange(List<Images> imgs) {
    if (imgs.length == 1) {
      return one(imgs[0], double.infinity, 300);
    } else if (imgs.length == 2) {
      return rowPair(imgs);
    } else if (imgs.length == 3) {
      return Row(children: [
        Flexible(flex: 5, child: one(imgs[0], 400, 300)),
        Flexible(
          flex: 2,
          child: columnPair([imgs[1], imgs[2]]),
        )
      ]);
    } else if (imgs.length == 4) {
      return Column(children: [
        rowPair([imgs[0], imgs[1]]),
        rowPair([imgs[2], imgs[3]]),
      ]);
    } else {
      // TODO over 5
      throw Exception("embed.type images length: ${imgs.length}");
    }
  }

  static Widget one(Images imgs, double width, double height) {
    return SizedBox(
        width: width,
        height: height,
        child: imageDecoration(EmbedImage(images: imgs)));
  }

  //https://vector-ium.com/flutter-image-widget/
  static Widget rowPair(List<Images> imgs) {
    return SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(children: [
          Expanded(child: imageDecoration(EmbedImage(images: imgs[0]))),
          Expanded(child: imageDecoration(EmbedImage(images: imgs[1])))
        ]));
  }

  static Widget columnPair(List<Images> imgs) {
    return SizedBox(
        height: 300,
        width: 500,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: imageDecoration(EmbedImage(images: imgs[0]))),
          Expanded(child: imageDecoration(EmbedImage(images: imgs[1])))
        ]));
  }
}

class EmbedImage extends StatelessWidget {
  final Images images;
  const EmbedImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.network(images.thumb, fit: BoxFit.cover),
      onTap: () async {
        show(context, Image.network(images.fullsize));
      },
    );
  }

  void show(BuildContext context, Widget image) {
    showDialog(
      barrierColor: Colors.black,
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            fullImage(image),
            closeButton(context),
          ],
        );
      },
    );
  }

  Widget fullImage(Widget image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 5,
            child: image,
          ),
        ),
      ],
    );
  }

  Widget closeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }
}
