import 'dart:convert';
import 'dart:io';

import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/models/auth_response.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/models/user.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http_parser/http_parser.dart';

enum AuthState { isClient, isStore }

class AuthenticationBLoC with ChangeNotifier {
  final prefs = new AuthUserPreferences();
  bool _imageProfileChanges = false;
  set imageProfileChange(bool value) {
    this._imageProfileChanges = value;
    notifyListeners();
  }

  bool get isImageProfileChange => this._imageProfileChanges;

  int _serviceSelect = 0;
  set serviceChange(int value) {
    this._serviceSelect = value;

    notifyListeners();
  }

  int get serviceSelect => this._serviceSelect;

  AuthState authState = AuthState.isStore;
  static String redirectUri =
      '${Environment.apiUrl}/api/apple/callbacks/sign_in_with_apple';
  static String clientId = 'com.kiozer';
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

  String _redirect;

  appleSignIn(BuildContext context) async {
    bool isIos = UniversalPlatform.isIOS;
    //bool isWeb = UniversalPlatform.isWeb;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId, redirectUri: Uri.parse(redirectUri)));

      final useBundleId = isIos ? true : false;

      showModalLoading(context);

      String address = '';
      String city = '';
      int number = 0;
      double long = 0;
      double lat = 0;

      if (prefs.locationCurrent) {
        address = prefs.addressSave['featureName'];
        city = prefs.addressSave['locality'];
      } else if (prefs.locationSearch) {
        address = prefs.addressSearchSave.mainText;
        city = prefs.addressSearchSave.secondaryText;
        number = int.parse(prefs.addressSearchSave.number);
        long = prefs.longSearch;
        lat = prefs.latSearch;
      }

      final res = await this.siginWithApple(
          credential.authorizationCode,
          credential.email,
          credential.givenName,
          useBundleId,
          credential.state,
          address,
          city,
          number,
          long,
          lat);

      Navigator.pop(context);

      return res;
    } catch (e) {
      print(e);
    }
  }

  Future signInWitchGoogle(context) async {
    try {
      final account = await _googleSignIn.signIn();

      final googleKey = await account.authentication;

      String address = '';
      String city = '';
      int number = 0;
      double long = 0;
      double lat = 0;

      showModalLoading(context);

      if (prefs.locationCurrent) {
        address = prefs.addressSave['featureName'];
        city = prefs.addressSave['locality'];
        long = prefs.longSearch;
        lat = prefs.latSearch;
      } else if (prefs.locationSearch) {
        address = prefs.addressSearchSave.mainText;
        city = prefs.addressSearchSave.secondaryText;
        number = int.parse(prefs.addressSearchSave.number);
        long = prefs.longSearch;
        lat = prefs.latSearch;
      }

      final authBack = await siginWithGoogleBack(
          googleKey.idToken, address, city, number, long, lat);

      return authBack;
    } catch (e) {
      print('error signin google');
      print(e);
    }
  }

  Future signInWithPhone(String phone, String code) async {
    try {
      String address = '';
      String city = '';
      int number = 0;
      double long = 0;
      double lat = 0;

      if (prefs.locationCurrent) {
        address = prefs.addressSave['featureName'];
        city = prefs.addressSave['locality'];
        long = prefs.longSearch;
        lat = prefs.latSearch;
      } else if (prefs.locationSearch) {
        address = prefs.addressSearchSave.mainText;
        city = prefs.addressSearchSave.secondaryText;
        number = int.parse(prefs.addressSearchSave.number);
        long = prefs.longSearch;
        lat = prefs.latSearch;
      }

      final authBack = await siginWithPhoneBack(
          phone, code, address, city, number, long, lat);

      return authBack;
    } catch (e) {
      print('error signin google');
      print(e);
    }
  }

  Future siginWithGoogleBack(token, String address, String city, int number,
      double long, double lat) async {
    final urlFinal = ('${Environment.apiUrl}/api/google/sign-in');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode({
          'token': token,
          'address': address,
          'city': city,
          'numberAddress': number,
          'long': long,
          'lat': lat
        }),
        headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      _guardarToken(loginResponse.token);

      prefs.setLocationSearch = true;
      prefs.setLocationCurrent = false;
      prefs.setSearchAddreses = placeStore;

      print(prefs.locationSearch);

      return true;
    } else {
      return false;
    }
  }

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

  Profile get profile => this._profileAuth;

  set profile(Profile valor) {
    this._profileAuth = valor;
    notifyListeners();
  }

  Store get storeAuth => this._storeAuth;

  set storeAuth(Store valor) {
    this._storeAuth = valor;

    serviceChange = valor.service;
    notifyListeners();
  }

  String get redirect => this._redirect;

  set redirect(String valor) {
    this._redirect = valor;
    //notifyListeners();
  }

  Future _guardarToken(String token) async {
    prefs.setLocationSearch = false;

    prefs.setLocationCurrent = false;
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');

    prefs.setLocationSearch = false;

    prefs.setLocationCurrent = false;

    //signOut();
  }

  Future logoutWeb() async {
    prefs.setToken = '';
    prefs.setLocationSearch = false;

    prefs.setLocationCurrent = false;

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

  Future editProfile(String uid, String username, String about, String name,
      String password, String imageAvatar, int service) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/store/edit');

    final data = {
      'uid': uid,
      'username': username,
      'name': name,
      'about': about,
      'password': password,
      'imageAvatar': imageAvatar,
      'service': service
    };

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      prefs.setLocationSearch = true;
      prefs.setSearchAddreses = placeStore;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editServiceStoreProfile(String uid, service) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/store/edit/service');

    final data = {'uid': uid, 'service': service};

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      prefs.setLocationSearch = true;
      prefs.setSearchAddreses = placeStore;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editInfoContactStoreProfile(
      String uid, String email, String phone) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/store/edit/contact/info');

    final data = {'uid': uid, 'email': email, 'phone': phone};

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      prefs.setLocationSearch = true;
      prefs.setSearchAddreses = placeStore;

      return true;
    } else if (resp.statusCode == 400) {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future siginWithApple(
      String code,
      String email,
      String firstName,
      bool useBundleId,
      String state,
      String address,
      String city,
      int number,
      double long,
      double lat) async {
    final urlFinal = '${Environment.apiUrl}/api/apple/sign_in_with_apple';

    final data = {
      'code': code,
      'email': email,
      'firstName': firstName,
      'useBundleId': useBundleId,
      'address': address,
      'city': city,
      'numberAddress': number,
      'long': long,
      'lat': lat,
      if (state != null) 'state': state
    };
    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      _guardarToken(loginResponse.token);

      prefs.setLocationSearch = true;
      prefs.setLocationCurrent = false;
      prefs.setSearchAddreses = placeStore;

      print(prefs.locationSearch);

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }

    // await getProfileByUserId(this.profile.user.uid);
  }

  Future siginWithPhoneBack(String numberPhone, String code, String address,
      String city, int number, double long, double lat) async {
    final urlFinal = '${Environment.apiUrl}/api/login/sign_in_with_phone';

    final data = {
      'phone': numberPhone,
      'code': 'code',
      'email': '',
      'firstName': '',
      'address': address,
      'city': city,
      'numberAddress': number,
      'long': long,
      'lat': lat,
    };
    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      prefs.setLocationSearch = true;
      prefs.setLocationCurrent = false;
      prefs.setSearchAddreses = placeStore;
      _guardarToken(loginResponse.token);

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }

    // await getProfileByUserId(this.profile.user.uid);
  }

  Future<String> uploadImageProfile(
      String fileName, String fileType, File image) async {
    final url = ('${Environment.apiUrl}/api/aws/upload/image-avatar');

    final mimeType = mime(image.path).split('/'); //image/jpeg

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    Map<String, String> headers = {
      "Content-Type": "image/mimeType",
      "x-token": token,
    };

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    imageUploadRequest.headers.addAll(headers);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');

      return null;
    }

    final respBody = jsonDecode(resp.body);

    //final respData = imageResponseToJson(resp.body);

    final respUrl = respBody['url'];

    // storeAuth.imageAvatar = respUrl;

    return respUrl;
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

      storeAuth = loginResponse.store;

      var placeStore = new PlaceSearch(
          description: storeAuth.user.uid,
          placeId: storeAuth.user.uid,
          structuredFormatting: new StructuredFormatting(
              mainText: storeAuth.address,
              secondaryText: storeAuth.city,
              number: storeAuth.number));

      prefs.setLocationSearch = true;
      prefs.setLocationCurrent = false;
      prefs.setSearchAddreses = placeStore;

      print(prefs.locationSearch);

      return true;
    } else {
      storeAuth = Store(user: User(uid: '0'));
      (UniversalPlatform.isWeb) ? prefs.setToken = '' : this.logout();
      return false;
    }
  }
}
