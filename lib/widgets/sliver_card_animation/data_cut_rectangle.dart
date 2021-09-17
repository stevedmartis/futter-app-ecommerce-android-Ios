import 'dart:math';
import 'package:flutter/material.dart';
import 'package:freeily/models/store.dart';

import '../../global/extension.dart';

class DataCutRectangle extends StatelessWidget {
  const DataCutRectangle(
      {Key key,
      @required this.size,
      @required this.percent,
      @required this.store})
      : super(key: key);

  final Size size;
  final double percent;
  final Store store;

  @override
  Widget build(BuildContext context) {
    final username = store.user.username;
    final about = store.about;
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.34, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: percent > 0.13
                          ? size.width / 2.5 * pow(percent, 2.5).clamp(0.0, 0.2)
                          : 0,
                      top: (percent > 0.48
                          ? size.height /
                              1.5 *
                              pow(percent, 10.5).clamp(0.0, 0.06)
                          : size.height * 0.0)),
                  child: Text(
                    store.name.capitalize(),
                    maxLines: 1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          if (percent < 0.50) ...[
            const SizedBox(
              height: 2,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: (1 - pow(percent, 0.001)).toDouble(),
              child: Container(
                child: Text(
                  '@$username',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: (1 - pow(percent, 0.001)).toDouble(),
              child: Container(
                child: Text(
                  '$about',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ),
            ),

            /* if (followService.followers > 0)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (1 - pow(percent, 0.001)).toDouble(),
                child: Text(
                  '${followService.followers}  Seguidores',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ), */
          ],
        ],
      ),
    );
  }
}
