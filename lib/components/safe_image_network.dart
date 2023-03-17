import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:velyvelo/services/http_service.dart';
import 'package:http/http.dart' as http;

class SafeImageNetwork extends StatelessWidget {
  final String url;
  final String? defaultImage;
  final BoxFit? fit;
  final double? height;

  const SafeImageNetwork(
      {Key? key, required this.url, this.fit, this.height, this.defaultImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    Future(() async {
      http.Response response = await http.get(Uri.parse(url));
      print(response.statusCode);
    });
    return CachedNetworkImage(
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      fit: fit,
      height: height,
      imageUrl: url,
      // progressIndicatorBuilder: (q, b, progress) {
      //   print(progress);
      //   return Text(progress.downloaded.toString());
      // },
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
