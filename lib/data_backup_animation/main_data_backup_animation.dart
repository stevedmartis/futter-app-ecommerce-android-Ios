import 'package:flutter/material.dart';
import 'data_backup_home.dart';

class MainDataBackupAnimationApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: DataBackupHome(),
    );
  }
}
