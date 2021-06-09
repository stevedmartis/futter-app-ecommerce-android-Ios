import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget cachedNetworkImage(String image) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
    placeholder: (context, url) =>
        Container(child: buildLoadingWidget(context)),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget cachedNetworkImageDetail(String image) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      height: MediaQuery.of(context).size.height * 0.36,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
            colorFilter:
                ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
    placeholder: (context, url) =>
        Container(child: buildLoadingWidget(context)),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
