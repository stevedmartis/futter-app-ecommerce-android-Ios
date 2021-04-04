import 'package:flutter/material.dart';

import 'pizza_order_details.dart';

class MainPizzaOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: PizzaOrderDetails(),
    );
  }
}
