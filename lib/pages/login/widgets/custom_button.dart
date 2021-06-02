import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final Widget image;
  final VoidCallback onPressed;
  final bool isPhone;

  const CustomButton(
      {@required this.textColor,
      @required this.text,
      @required this.color,
      @required this.onPressed,
      this.image,
      this.isPhone = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: image != null
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: color,
                primary: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (!isPhone)
                      ? Padding(
                          padding: const EdgeInsets.only(
                            right: kPaddingL,
                            top: 20,
                            bottom: 20,
                          ),
                          child: image,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              right: kPaddingL, top: 20, bottom: 20, left: 10),
                          child: image,
                        ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )
          : TextButton(
              style: TextButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.all(kPaddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: kPaddingL + 20),
                    child: image,
                  ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}
