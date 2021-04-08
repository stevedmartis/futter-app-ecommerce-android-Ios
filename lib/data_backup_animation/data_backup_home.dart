import 'package:flutter/material.dart';

import 'data_backup_cloud_page.dart';
import 'data_backup_completed_page.dart';
import 'data_backup_initial_page.dart';

const mainDataBackupColor = Color(0xFF5113AA);
const secondaryDataBackupColor = Color(0xFFBC53FA);
const backgroundColor = Color(0xFFfce7fe);

class DataBackupHome extends StatefulWidget {
  @override
  _DataBackupHomeState createState() => _DataBackupHomeState();
}

class _DataBackupHomeState extends State<DataBackupHome>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _progressAnimation;
  Animation<double> _cloudOutAnimation;
  Animation<double> _endingAnimation;
  Animation<double> _bubblesAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 7,
      ),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.65,
      ),
    );
    _cloudOutAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.7,
        0.85,
        curve: Curves.easeOut,
      ),
    );
    _bubblesAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: Curves.decelerate,
      ),
    );
    _endingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.8,
        1.0,
        curve: Curves.decelerate,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          DataBackupInitialPage(
            progressAnimation: _progressAnimation,
            onAnimationStarted: () {
              _animationController.forward();
            },
          ),
          DataBackupCloudPage(
            progressAnimation: _progressAnimation,
            cloudOutAnimation: _cloudOutAnimation,
            bubblesAnimation: _bubblesAnimation,
          ),
          DataBackupCompletedPage(
            endingAnimation: _endingAnimation,
          ),
        ],
      ),
    );
  }
}
