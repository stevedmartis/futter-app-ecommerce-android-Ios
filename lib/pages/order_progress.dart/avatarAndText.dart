import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/widgets/cross_fade.dart';
import 'package:flutter/material.dart';

class AvatarAndText extends StatefulWidget {
  AvatarAndText(
      {this.animationController,
      this.progressBarOne,
      this.progressBarTwo,
      this.progressBarThree});

  final AnimationController animationController;
  final Animation<double> progressBarOne;
  final Animation<double> progressBarTwo;
  final Animation<double> progressBarThree;
  _AvatarAndTextState createState() => _AvatarAndTextState();
}

class _AvatarAndTextState extends State<AvatarAndText>
    with TickerProviderStateMixin {
  final textOne = "Pedido enviada y recibida.";
  final imageTwo = "assets/images/Pan.png";
  final textTwo = "Estan preparando tu pedido.";
  final imageThree = "assets/images/FoodPackage.png";
  final textThree = "Tu pedido va en camino";

  final imageFour = "assets/images/FoodPackage.png";
  final textFour = "El pedido llego a tu dirección!";
  var actualImage = "assets/images/Ober.png";
  var actualText = "";

  @override
  void initState() {
    super.initState();

    widget.animationController.addListener(() {
      if (widget.animationController.value > 0.100 &&
          widget.progressBarTwo.value <= 0.0) {
        setState(() {
          actualText = textOne;
        });
      } else if (widget.animationController.value > 0.450 &&
          widget.progressBarTwo.value <= 1.0 &&
          widget.progressBarThree.value <= 0.0) {
        setState(() {
          actualImage = imageTwo;
          actualText = textTwo;
        });
      } else if (widget.animationController.value > 0.900 &&
          widget.animationController.value <= 1.000 &&
          widget.progressBarThree.value < 1.0) {
        setState(() {
          actualImage = imageThree;
          actualText = textThree;
        });
      } else if (widget.progressBarThree.value >= 1.0) {
        actualText = textFour;
      }
    });
  }

  @override
  void dispose() {
    //widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvatarAnimation(
        controller: widget.animationController,
        image: actualImage,
        text: actualText);
  }
}

class AvatarAnimation extends StatelessWidget {
  AvatarAnimation({Key key, this.controller, this.image, this.text})
      : super(key: key);

  final AnimationController controller;
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /* Container(
            child: Image.asset(image, width: 125),
          ), */
          SizedBox(height: 15),
          CrossFade<String>(
            initialData: this.text,
            data: this.text,
            builder: (value) => Container(
              child: Text(
                value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
