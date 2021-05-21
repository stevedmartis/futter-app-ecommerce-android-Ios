import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/responses/images_product_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/responses/message_error_response.dart';
import 'package:australti_ecommerce_app/responses/store_category_response.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:mime_type/mime_type.dart';
import "package:universal_html/html.dart" as html;
import 'package:path/path.dart' as p;

class StoreProductService with ChangeNotifier {
  final prefs = new AuthUserPreferences();
  ProfileStoreCategory _catalogo;
  List<File> _images;
  ProfileStoreCategory get catalogo => this._catalogo;

  set catalogo(ProfileStoreCategory valor) {
    this._catalogo = valor;
    // notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future createCatalogo(ProfileStoreCategory category) async {
    // this.authenticated = true;

    final urlFinal = Uri.https('${Environment.apiUrl}', '/api/catalogo/new');

    final token = await this._storage.read(key: 'token');

    final resp = await http.post(urlFinal,
        body: jsonEncode(catalogo),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = storeCategoriesResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editCatalogo(ProfileStoreCategory catalogo) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/catalogo/update/catalogo');

    final resp = await http.post(urlFinal,
        body: jsonEncode(catalogo),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = storeCategoriesResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteCatalogo(String catalogoId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/catalogo/delete/$catalogoId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionCatalogo(
      List<ProfileStoreCategory> catalogos, int position, String userId) async {
    // this.authenticated = true;

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/catalogo/update/position');

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'catalogos': catalogos, 'userId': userId};

    final resp = await http.post(urlFinal,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<ImagesResponse> uploadImagesProducts(
      List<http.MultipartFile> images, String id) async {
    final urlUploadMultiFiles =
        ('${Environment.apiUrl}/api/aws/upload/images/product');

    final urlUploadFile =
        ('${Environment.apiUrl}/api/aws/upload/image/product');

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    Map<String, String> headers = {
      "Content-Type": "image/mimeType",
      "x-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2MDJjNDIwOTJjMzVkMzUxNjBkNjdkYzMiLCJpYXQiOjE2MjE1NDA5NTksImV4cCI6MTYyMTYyNzM1OX0.tHY7BxYlB482dpOdbhxd2BmxyMxrnhReIJQQwJB-XL4",
      'id': "602c42092c35d35160d67dc3",
    };

    final imageUploadRequest = http.MultipartRequest(
        'POST',
        (images.length > 1)
            ? Uri.parse(urlUploadMultiFiles)
            : Uri.parse(urlUploadFile));

    imageUploadRequest.files.addAll(images);

    imageUploadRequest.headers.addAll(headers);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');

      return null;
    }

    final respUrl = imagesResponseFromJson(resp.body);

    return respUrl;
  }

  Future multiPartFileImage(File image) async {
    final mimeType = mime(image.path).split('/');

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    return file;
  }

  Future multiPartFileImageWeb(
      List<int> imageFileBytes, html.File image) async {
    final mimeType = mime(image.name).split('/');
    final file = http.MultipartFile.fromBytes('file', imageFileBytes,
        filename: image.name, contentType: MediaType(mimeType[0], mimeType[1]));

    return file;
  }

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }
}
