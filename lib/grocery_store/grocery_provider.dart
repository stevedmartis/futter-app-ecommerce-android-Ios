import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';

class GroceryProvider extends InheritedWidget {
  final GroceryStoreBLoC bloc;
  final Widget child;

  GroceryProvider({
    @required this.bloc,
    @required this.child,
  }) : super(child: child);

  static GroceryProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GroceryProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
