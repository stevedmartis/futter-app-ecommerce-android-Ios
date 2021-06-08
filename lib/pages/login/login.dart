import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'widgets/custom_clippers/index.dart';
import 'widgets/header.dart';
import 'widgets/login_form.dart';

class Login extends StatefulWidget {
  final double screenHeight;

  const Login({
    @required this.screenHeight,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _headerTextAnimation;
  Animation<double> _formElementAnimation;
  Animation<double> _whiteTopClipperAnimation;
  Animation<double> _blueTopClipperAnimation;
  Animation<double> _greyTopClipperAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );

    final fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _headerTextAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
    ));
    _formElementAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.easeInOut,
      ),
    ));

    final clipperOffsetTween = Tween<double>(
      begin: widget.screenHeight,
      end: 0.0,
    );
    _blueTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _greyTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.35,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _whiteTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    Color gradientStart = Color(0xffFF8236); //Change start gradient color here
    Color gradientEnd = currentTheme.accentColor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _whiteTopClipperAnimation,
              builder: (_, Widget child) {
                return ClipPath(
                  clipper: WhiteTopClipper(
                    yOffset: _whiteTopClipperAnimation.value,
                  ),
                  child: child,
                );
              },
              child:
                  Container(color: currentTheme.accentColor.withOpacity(0.10)),
            ),
            AnimatedBuilder(
                animation: _greyTopClipperAnimation,
                builder: (_, Widget child) {
                  return ClipPath(
                    clipper: GreyTopClipper(
                      yOffset: _greyTopClipperAnimation.value,
                    ),
                    child: child,
                  );
                },
                child: Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [gradientStart, gradientEnd],
                        begin: const FractionalOffset(0.5, 0.0),
                        end: const FractionalOffset(0.0, 0.5),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                )),
            AnimatedBuilder(
              animation: _blueTopClipperAnimation,
              builder: (_, Widget child) {
                return ClipPath(
                  clipper: BlueTopClipper(
                    yOffset: _blueTopClipperAnimation.value,
                  ),
                  child: child,
                );
              },
              child: Container(color: currentTheme.scaffoldBackgroundColor),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kPaddingL),
                child: Column(
                  children: <Widget>[
                    Header(animation: _headerTextAnimation),
                    SizedBox(
                      height: size.height / 4.1,
                    ),
                    LoginForm(animation: _formElementAnimation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
