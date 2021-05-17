import 'dart:io';

import 'package:australti_ecommerce_app/grocery_store/grocery_store_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showMaterialCupertinoBottomSheet(
    BuildContext context, String titulo, String subtitulo) {
  if (Platform.isIOS) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: GroceryStoreCart(
            cartHome: true,
          )),
    );
  } else if (Platform.isAndroid) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Action One'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Action Two'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
