import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:flutter/material.dart';

class MainStoreServicesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: StorePrincipalHome(),
    );
  }
}
