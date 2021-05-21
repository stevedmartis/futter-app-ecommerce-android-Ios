import 'dart:convert';

import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/models/auth_response.dart';
import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

enum AuthState { isClient, isStore }

class AuthenticationBLoC with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  AuthState authState = AuthState.isStore;
  static String redirectUri =
      'https://api.gettymarket.com/api/apple/callbacks/sign_in_with_apple';

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  final _storage = new FlutterSecureStorage();
  ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  bool isAuthenticated = false;

  Profile _profileAuth;

  Store _storeAuth;

  void changeToStore() {
    authState = AuthState.isStore;
    notifyListeners();
  }

  void changeToClient() {
    authState = AuthState.isStore;
    notifyListeners();
  }

  ValueNotifier<bool> get bottomVisible => this.notifierBottomBarVisible;

  set bottomVisible(ValueNotifier<bool> valor) {
    this.notifierBottomBarVisible = valor;
    notifyListeners();
  }

  void changeToAuth(LoginResponse login) async {
    isAuthenticated = !isAuthenticated;
    await this._guardarToken(login.token);

    profile = login.profile;
  }

  Profile get profile => this._profileAuth;

  set profile(Profile valor) {
    this._profileAuth = valor;
    notifyListeners();
  }

  Store get storeAuth => this._storeAuth;

  set storeAuth(Store valor) {
    this._storeAuth = valor;
    //notifyListeners();
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    //signOut();
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

/*   bool get bottomVisible => this._bottomVisible;

  set bottomVisible(bool valor) {
    this._bottomVisible = valor;
    notifyListeners();
  } */

  Future siginWithApple(String code, String email, String firstName,
      bool useBundleId, String state) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/apple/sign_in_with_apple');

    final data = {
      'code': code,
      'email': email,
      'firstName': firstName,
      'useBundleId': useBundleId,
      if (state != null) 'state': state
    };
    final resp = await http.post(urlFinal,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.changeToAuth(loginResponse);

      // this.authenticated = true;

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }

    // await getProfileByUserId(this.profile.user.uid);
  }

  Future<bool> isLoggedIn() async {
    var urlFinal = ('${Environment.apiUrl}/api/login/renew');

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    //this.logout();
    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.changeToAuth(loginResponse);

      return true;
    } else {
      (UniversalPlatform.isWeb) ? prefs.setToken = '' : this.logout();
      return false;
    }
  }
}
