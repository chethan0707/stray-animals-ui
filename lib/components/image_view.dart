import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends ConsumerWidget {
  final String url;
  const ImageView({required this.url, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(
            url,
          ),
        ),
      ),
    );
  }
}
