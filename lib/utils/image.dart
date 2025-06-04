
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

Future<Uint8List> imageToUint8List(Image image, {int? width, int? height}) async {
  // 获取 ImageProvider
  final ImageProvider imageProvider = image.image;

  final Completer<ui.Image> completer = Completer();
  final ImageStream stream = imageProvider.resolve(ImageConfiguration());
  final listener = ImageStreamListener((ImageInfo info, _) {
    completer.complete(info.image);
  });
  stream.addListener(listener);
  final ui.Image uiImage = await completer.future;
  stream.removeListener(listener);

  // 转成 ByteData（PNG 格式）
  final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}

Image Uint8ListToImage(Uint8List bytes) {
  return Image.memory(bytes);
}
