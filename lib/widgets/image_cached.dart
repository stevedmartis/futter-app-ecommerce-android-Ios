import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget cachedNetworkImage(
  String image,
) {
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

Widget cachedNetworkImageBackground(
  String image,
) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
      ),
    ),
    placeholder: (context, url) =>
        Container(child: buildLoadingWidget(context)),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget cachedProductNetworkImage(String image) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.lighten)),
      ),
    ),
    placeholder: (context, url) =>
        Container(child: buildLoadingWidget(context)),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget cachedContainNetworkImage(String image) {
  var type = image.split(".").last;

  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: (type.toLowerCase() == 'png') ? BoxFit.contain : BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
    placeholder: (context, url) =>
        Container(child: buildLoadingWidget(context)),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
