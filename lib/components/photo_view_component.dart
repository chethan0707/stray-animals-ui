import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewComp extends ConsumerWidget {
  final String url;
  const PhotoViewComp({required this.url, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(
            "http://localhost:8080/file/download/$url",
          ),
        ),
      ),
    );
  }
}
