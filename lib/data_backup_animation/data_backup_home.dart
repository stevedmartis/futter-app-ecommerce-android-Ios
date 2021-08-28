import 'package:freeily/responses/orderStoresProduct.dart';
import 'package:freeily/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'data_backup_cloud_page.dart';
import 'data_backup_completed_page.dart';
import 'data_backup_initial_page.dart';

const mainDataBackupColor = Color(0xff32D73F);
const secondaryDataBackupColor = Color(0xff3CFF50);

class DataBackupHome extends StatefulWidget {
  final List<Order> orders;

  DataBackupHome({this.orders});
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
        seconds: 3,
      ),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.1,
      ),
    );
    _cloudOutAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.1,
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
        0.6,
        1.0,
        curve: Curves.decelerate,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
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
            ordersCreate: widget.orders,
          ),
        ],
      ),
    );
  }
}
