import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:australti_ecommerce_app/widgets/cross_fade.dart';
import 'package:flutter/material.dart';

class AvatarAndText extends StatefulWidget {
  AvatarAndText(
      {Key key,
      this.animationController,
      this.progressBarOne,
      this.progressBarTwo,
      this.progressBarThree,
      this.principal,
      this.order})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> progressBarOne;
  final Animation<double> progressBarTwo;
  final Animation<double> progressBarThree;

  final Order order;

  final bool principal;
  _AvatarAndTextState createState() => _AvatarAndTextState();
}

class _AvatarAndTextState extends State<AvatarAndText>
    with TickerProviderStateMixin {
  final textOne = "Pedido enviado y recibido ...";
  final imageTwo = "assets/images/Pan.png";
  final textTwo = "Estan preparando tu pedido ...";
  final imageThree = "assets/images/FoodPackage.png";
  final textThree = "Tu pedido va en camino ...";

  final imageFour = "assets/images/FoodPackage.png";
  final textFour = "El pedido llego a tu dirección!";
  var actualImage = "assets/images/Ober.png";
  var actualText = "";

  @override
  void initState() {
    super.initState();

    if (widget.order.isActive && !widget.order.isPreparation) {
      setState(() {
        actualText = textOne;
      });
    } else if (widget.order.isPreparation && !widget.order.isDelivery) {
      setState(() {
        actualImage = imageTwo;
        actualText = textTwo;
      });
    } else if (widget.order.isDelivery && !widget.order.isFinalice) {
      setState(() {
        actualImage = imageThree;
        actualText = textThree;
      });
    } else if (widget.order.isFinalice) {
      actualText = textFour;
    }
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
        text: actualText,
        principal: widget.principal);
  }
}

class AvatarAnimation extends StatelessWidget {
  AvatarAnimation(
      {Key key, this.controller, this.image, this.text, this.principal})
      : super(key: key);

  final AnimationController controller;
  final String image;
  final String text;
  final bool principal;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: (principal) ? Alignment.centerLeft : Alignment.center,
      padding: EdgeInsets.only(
          right: (principal) ? 0 : 20,
          top: (principal) ? 5 : 0,
          left: (principal) ? 0 : 20),
      height: (principal) ? 30 : 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /* Container(
            child: Image.asset(image, width: 125),
          ), */
          SizedBox(height: (principal) ? 0 : 15),
          CrossFade<String>(
            initialData: this.text,
            data: this.text,
            builder: (value) => Container(
              child: Text(
                value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: (principal) ? 12 : 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
