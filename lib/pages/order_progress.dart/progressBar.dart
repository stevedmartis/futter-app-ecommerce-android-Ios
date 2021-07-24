import 'package:australti_ecommerce_app/pages/order_progress.dart/avatarAndText.dart';
import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'util.dart';
import 'package:expandable/expandable.dart';

class ProgressBar extends StatefulWidget {
  ProgressBar({this.order});

  final Order order;
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBar(
      controller: animationController,
      order: widget.order,
    );
  }
}

class AnimatedBar extends StatefulWidget {
  final Order order;
  AnimatedBar({Key key, this.order, this.controller})
      : dotOneColor = ColorTween(
          begin: FoodColors.Grey,
          end: FoodColors.Yellow,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.000,
              0.100,
              curve: Curves.linear,
            ),
          ),
        ),
        textOneStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400,
              color: FoodColors.Grey,
              fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.000,
              0.100,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarOne = Tween(
                begin: 0.0,
                end: (order.isActive & (!order.isPreparation))
                    ? 0.5
                    : (order.isPreparation)
                        ? 1.0
                        : 0.0)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.100, 0.450),
          ),
        ),
        dotTwoColor = ColorTween(
          begin: FoodColors.Grey,
          end: FoodColors.Yellow,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.450,
              0.550,
              curve: Curves.linear,
            ),
          ),
        ),
        textTwoStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400,
              color: FoodColors.Grey,
              fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarTwo = Tween(
                begin: 0.0,
                end: (order.isPreparation & (!order.isSend))
                    ? 0.5
                    : (order.isSend)
                        ? 1.0
                        : 0.0)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.550, 0.900),
          ),
        ),
        dotThreeColor = ColorTween(
          begin: FoodColors.Grey,
          end: FoodColors.Yellow,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarThree = Tween(
                begin: 0.0,
                end: (order.isSend && (!order.isFinalice))
                    ? 0.5
                    : (order.isFinalice)
                        ? 1.0
                        : 0.0)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.900, 1.000), // 900, 1.000
          ),
        ),
        textThreeStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400,
              color: FoodColors.Grey,
              fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.0,
              curve: Curves.linear,
            ),
          ),
        ),
        dotFourColor = ColorTween(
          begin: FoodColors.Grey,
          end: FoodColors.Yellow,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarFour = Tween(
                begin: 0.0,
                end: (order.isFinalice && (!order.isSend))
                    ? 0.5
                    : (order.isFinalice)
                        ? 1.0
                        : 0.0)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<Color> dotOneColor;
  final Animation<TextStyle> textOneStyle;
  final Animation<double> progressBarOne;
  final Animation<Color> dotTwoColor;

  final Animation<TextStyle> textTwoStyle;
  final Animation<double> progressBarTwo;
  final Animation<Color> dotThreeColor;
  final Animation<Color> dotFourColor;
  final Animation<TextStyle> textThreeStyle;
  final Animation<double> progressBarThree;

  final Animation<double> progressBarFour;

  @override
  _AnimatedBarState createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with TickerProviderStateMixin {
  final dotSize = 30.0;

  AnimationController _animationController;

  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressBar() {
      final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width / 1.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Text('${(controller.value * 100.0).toStringAsFixed(1)}%'),
                Container(
                  width: dotSize + widget.progressBarOne.value * 6,
                  height: dotSize + widget.progressBarOne.value * 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 0.5 + widget.progressBarOne.value * 3,
                          color: (widget.progressBarOne.value >= 0.5)
                              ? currentTheme.primaryColor
                              : Colors.grey)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    child: (widget.progressBarOne.value != 1.0)
                        ? FaIcon(
                            FontAwesomeIcons.archive,
                            size: 13,
                            color: (widget.progressBarOne.value >= 0.5)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                          )
                        : Icon(
                            Icons.check_circle,
                            size: 20 + widget.progressBarOne.value * 6,
                            color: currentTheme.primaryColor,
                          ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: FoodColors.Grey,
                      value: widget.progressBarOne.value,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(FoodColors.Yellow),
                    ),
                  ),
                ),

                Container(
                  width: dotSize + widget.progressBarTwo.value * 6,
                  height: dotSize + widget.progressBarTwo.value * 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 0.5 + widget.progressBarTwo.value * 3,
                          color: (widget.progressBarTwo.value >= 0.5)
                              ? currentTheme.primaryColor
                              : Colors.grey)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    child: (widget.progressBarTwo.value != 1.0)
                        ? FaIcon(
                            FontAwesomeIcons.boxOpen,
                            size: 13,
                            color: (widget.progressBarTwo.value >= 0.5)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                          )
                        : Icon(
                            Icons.check_circle,
                            size: 20 + widget.progressBarTwo.value * 6,
                            color: currentTheme.primaryColor,
                          ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: FoodColors.Grey,
                      value: widget.progressBarTwo.value,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(FoodColors.Yellow),
                    ),
                  ),
                ),

                Container(
                  width: dotSize + widget.progressBarThree.value * 6,
                  height: dotSize + widget.progressBarThree.value * 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 0.5 + widget.progressBarThree.value * 3,
                          color: (widget.progressBarThree.value >= 0.5)
                              ? currentTheme.primaryColor
                              : Colors.grey)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    child: (widget.progressBarThree.value != 1.0)
                        ? FaIcon(
                            FontAwesomeIcons.truckLoading,
                            size: 13,
                            color: (widget.progressBarThree.value >= 0.5)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                          )
                        : Icon(
                            Icons.check_circle,
                            size: 20 + widget.progressBarThree.value * 6,
                            color: currentTheme.primaryColor,
                          ),
                  ),
                ),

                /*  Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dotSize / 2),
                        color: Colors.grey),
                  ), */

                Expanded(
                  flex: 1,
                  child: Container(
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: FoodColors.Grey,
                      value: widget.progressBarThree.value,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(FoodColors.Yellow),
                    ),
                  ),
                ),

                Container(
                  width: dotSize + widget.progressBarFour.value * 6,
                  height: dotSize + widget.progressBarFour.value * 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 0.5 + widget.progressBarFour.value * 3,
                          color: (widget.progressBarFour.value >= 1.0)
                              ? currentTheme.primaryColor
                              : Colors.grey)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    child: (widget.progressBarFour.value != 1.0)
                        ? FaIcon(
                            FontAwesomeIcons.home,
                            size: 13,
                            color: (widget.progressBarFour.value >= 1.0)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                          )
                        : Icon(
                            Icons.check_circle,
                            size: 20 + widget.progressBarFour.value * 6,
                            color: currentTheme.primaryColor,
                          ),
                  ),
                ),
              ],
            ),
          ),
          AvatarAndText(
            animationController: widget.controller,
            progressBarOne: widget.progressBarOne,
            progressBarTwo: widget.progressBarTwo,
            progressBarThree: widget.progressBarThree,
          ),
          /* Container(
              margin: EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Recibida',
                    style: widget.textOneStyle.value,
                  ),
                  Text(
                    'Preparando',
                    style: widget.textTwoStyle.value,
                  ),
                  Text(
                    'Enviado',
                    style: widget.textThreeStyle.value,
                  ),
                  Text(
                    'Lista',
                    style: widget.textThreeStyle.value,
                  ),
                ],
              ),
            ) */
        ],
      );
    }

    buildCollapsed2() {
      return Column(
        children: [progressBar()],
      );
    }

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        child: AnimatedBuilder(
            animation: widget.controller,
            builder: (BuildContext context, Widget child) => ExpandableNotifier(
                    child: ScrollOnExpand(
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: currentTheme.cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expandable(
                          collapsed: progressBar(),
                          expanded: buildCollapsed2(),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Builder(
                          builder: (context) {
                            var controller = ExpandableController.of(context,
                                required: true);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (!controller.expanded)
                                      ? 'Ver más'
                                      : 'Ver menos',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.toggle();
                                    },
                                    icon: (!controller.expanded)
                                        ? Icon(
                                            Icons.expand_more,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.expand_less,
                                            color: Colors.white,
                                          ))
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
