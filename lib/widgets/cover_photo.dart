import 'package:flutter/material.dart';
import 'package:freeily/profile_store.dart/profile.dart';
import 'package:freeily/widgets/image_cached.dart';

class CoverPhoto extends StatelessWidget {
  const CoverPhoto({
    Key key,
    @required this.imageAvatar,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final String imageAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: size.width * 0.30,
      height: size.height * 0.18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: (imageAvatar != "")
            ? Container(
                child: cachedNetworkImage(
                  imageAvatar,
                ),
              )
            : Image.asset(currentProfile.imageAvatar),
      ),
    );
  }
}
