import 'package:freeily/profile_store.dart/profile_store_auth.dart';
import 'package:flutter/material.dart';

class MainProfileStoreApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: ProfileStoreAuth(),
    );
  }
}
