import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/responses/store_response.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

class StoresProvider {
  Future<StoresResponse> getSearchPrincipalByQuery(String query) async {
    try {
      final urlFinal =
          Uri.https('${Environment.apiUrl}', '/api/search/principal/$query');

      final resp = await http.get(
        urlFinal,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthenticationBLoC.getToken(),
        },
      );

      final profilesResponse = storesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return StoresResponse.withError("$error");
    }
  }
}
