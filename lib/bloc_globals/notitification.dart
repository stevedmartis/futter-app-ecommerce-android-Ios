import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationModel extends ChangeNotifier {
  int _number = 0;

  dynamic _payload;
  AnimationController _bounceController;

  int get number => this._number;

  final _numberSteamNotifiBell = BehaviorSubject<int>();
  dynamic get payload => this._payload;

  set payload(dynamic value) {
    this._payload = value;
    notifyListeners();
  }

  AnimationController get bounceController => this._bounceController;

  set bounceController(AnimationController controller) {
    this._bounceController = controller;
  }

  int _numberNotifiBell = 0;
  AnimationController _bounceControllerNotifiBeel;

  int get numberNotifiBell => this._numberNotifiBell;

  set numberNotifiBell(int value) {
    this._numberNotifiBell = value;
    //notifyListeners();
  }

  AnimationController get bounceControllerBell =>
      this._bounceControllerNotifiBeel;

  set bounceControllerBell(AnimationController controller) {
    this._bounceControllerNotifiBeel = controller;
  }

  @override
  void dispose() {
    _numberSteamNotifiBell.close();
    super.dispose();
  }

  BehaviorSubject<int> get numberSteamNotifiBell => _numberSteamNotifiBell;
}
