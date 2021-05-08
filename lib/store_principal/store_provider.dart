import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:flutter/material.dart';

class StoreProvider extends InheritedWidget {
  final StoreBLoC bloc;
  final Widget child;

  StoreProvider({
    @required this.bloc,
    @required this.child,
  }) : super(child: child);

  static StoreProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
