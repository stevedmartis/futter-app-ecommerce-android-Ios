import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/global/enviroments.dart';

import 'package:flutter/material.dart';
import 'package:freeily/preferences/user_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:universal_platform/universal_platform.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  final prefs = new AuthUserPreferences();

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connect() async {
    final token = (!UniversalPlatform.isWeb)
        ? await AuthenticationBLoC.getToken()
        : prefs.token;

    // Dart client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.on('connection', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
