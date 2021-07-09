import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/responses/message_error_response.dart';
import 'package:australti_ecommerce_app/responses/search_stores_products_response.dart';
import 'package:australti_ecommerce_app/responses/stores_list_principal_response.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class StoreService with ChangeNotifier {
  final _storage = new FlutterSecureStorage();

  String token = '';
  final prefs = new AuthUserPreferences();
  Future getStoresAuthListServices(String uid) async {
    final token = await this._storage.read(key: 'token');
    final urlFinal =
        ('${Environment.apiUrl}/api/store/auth/stores/list/principal');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final StoresListResponse storesListResponse =
          storesListResponseFromJson(resp.body);

      return storesListResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future getStoresListServices(String uid) async {
    final urlFinal = ('${Environment.apiUrl}/api/store/stores/list/principal');

    final resp = await http.get(Uri.parse(urlFinal), headers: {
      'Content-Type': 'application/json',
    });

    if (resp.statusCode == 200) {
      final StoresListResponse storesListResponse =
          storesListResponseFromJson(resp.body);

      return storesListResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future getStoreAndProductsByValue(String value, String uid) async {
    final urlFinal = ('${Environment.apiUrl}/api/search/principal/$value/$uid');

    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final SearchStoresProductsListResponse storesProductsSearchListResponse =
          storesProductsListResponseFromJson(resp.body);

      return storesProductsSearchListResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future getStoresLocationListServices(String location, String uid) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/store/stores/location/list/principal/$location/$uid');

    final resp = await http.get(Uri.parse(urlFinal), headers: {
      'Content-Type': 'application/json',
    });

    if (resp.statusCode == 200) {
      final StoresListResponse storesListResponse =
          storesListResponseFromJson(resp.body);

      return storesListResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }
}
