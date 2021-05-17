import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:flutter/material.dart';

class CustomProvider extends InheritedWidget {
  //final loginBloc = new LoginBloc();

  // final registerBloc = new RegisterBloc();

  //final storeBloc = new StoreBLoC();
  final groceryStoreBloc = new GroceryStoreBLoC();

  final myLocationBloc = new MyLocationBloc();

  // final roomBloc = new RoomBloc();

  // final productBloc = ProductBloc();

  static CustomProvider _instancia;

  factory CustomProvider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new CustomProvider._internal(key: key, child: child);
    }

    return _instancia;
  }

  CustomProvider._internal({Key key, Widget child})
      : super(key: key, child: child);

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  /*  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .loginBloc;
  }

  static RegisterBloc registerBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .registerBloc;
  }
 */
  /*  static StoreBLoC storeBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .storeBloc;
  }
 */
  static GroceryStoreBLoC groceryStoreBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .groceryStoreBloc;
  }

  static MyLocationBloc myLocationBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .myLocationBloc;
  }
}
