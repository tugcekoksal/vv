import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SafeImageNetwork extends StatelessWidget {
  final String url;
  final String? defaultImage;
  final BoxFit? fit;
  final double? height;

  const SafeImageNetwork(
      {super.key, required this.url, this.fit, this.height, this.defaultImage});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      fit: fit,
      height: height,
      imageUrl: url,
      placeholder: (context, url) => Image(
        image: const AssetImage('assets/loading.gif'),
        fit: fit,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(
            defaultImage != null ? defaultImage! : 'assets/no-image.png'),
        fit: fit,
      ),
    );
  }
}
