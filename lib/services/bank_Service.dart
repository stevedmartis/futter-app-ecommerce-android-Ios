import 'dart:convert';

import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/models/bank_account.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/responses/bank_account.dart';
import 'package:australti_ecommerce_app/responses/message_error_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

class BankService with ChangeNotifier {
  final prefs = new AuthUserPreferences();
  final _storage = new FlutterSecureStorage();

  List<Bank> banks = [
    Bank(
        id: '0',
        nameBank: 'Banco de Chile / Edwards-CITI',
        image: 'assets/logos/logos_banks/bancochile_logo.png'),
    Bank(
        id: '1',
        nameBank: 'Banco Estado',
        image: 'assets/logos/logos_banks/banco_estado.png'),
    Bank(
        id: '2',
        nameBank: 'ScotiaBank',
        image: 'assets/logos/logos_banks/scotiabank.png'),
    Bank(
        id: '3',
        nameBank: 'Banco de Creditos e Inversiones',
        image: 'assets/logos/logos_banks/bci.png'),
    Bank(
        id: '3',
        nameBank: 'CoprBanca',
        image: 'assets/logos/logos_banks/corpbanca.jpeg'),
    Bank(
        id: '4',
        nameBank: 'Banco Bice',
        image: 'assets/logos/logos_banks/banco_bice.png'),
    Bank(id: '5', nameBank: 'HSBC Bank', image: ''),
    Bank(
        id: '6',
        nameBank: 'Banco Santander',
        image: 'assets/logos/logos_banks/santander.png'),
    Bank(
        id: '7',
        nameBank: 'Banco Itaú',
        image: 'assets/logos/logos_banks/itau.png'),
    Bank(
        id: '8',
        nameBank: 'Banco Security',
        image: 'assets/logos/logos_banks/security.png'),
    Bank(
        id: '9',
        nameBank: 'Banco BBVA',
        image: 'assets/logos/logos_banks/bbvva.png'),
    Bank(
        id: '10',
        nameBank: 'Banco del Desarrollo',
        image: 'assets/logos/logos_banks/banco_dev.png'),
    Bank(
        id: '11',
        nameBank: 'Banco Falabella',
        image: 'assets/logos/logos_banks/falabella.png'),
    Bank(
        id: '12',
        nameBank: 'Banco Ripley',
        image: 'assets/logos/logos_banks/ripley.png'),
    Bank(id: '13', nameBank: 'Rabo Bank', image: ''),
    Bank(
        id: '14',
        nameBank: 'Banco Consorcio',
        image: 'assets/logos/logos_banks/conso.png'),
    Bank(
        id: '14',
        nameBank: 'Banco Paris',
        image: 'assets/logos/logos_banks/paris.jpeg')
  ];

  getBanks(String value) {
    if (value.length >= 3) {
      final find = banks.where(
          (item) => item.nameBank.toLowerCase().contains(value.toLowerCase()));

      if (find.length > 0) {
        return find.first;
      }
    } else if (value.length == 0) {
      return banks;
    }
  }

  Future createAccountBank(String uid, String bankId, String name, String rut,
      String typeAccount, String numberAccount, String email) async {
    final urlFinal = ('${Environment.apiUrl}/api/bank/account/create/');

    final data = {
      'user': uid,
      "bankId": bankId,
      "name": name,
      "rut": rut,
      "typeAccount": typeAccount,
      "numberAccount": numberAccount,
      "email": email,
    };

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final bankAccountResponse = bankAccountFromJson(resp.body);

      return bankAccountResponse;
    } else if (resp.statusCode == 400) {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editAccountBank(String id, String bankId, String name, String rut,
      String typeAccount, String numberAccount, String email) async {
    final urlFinal = ('${Environment.apiUrl}/api/bank/account/edit/');

    final data = {
      'id': id,
      "bankId": bankId,
      "name": name,
      "rut": rut,
      "typeAccount": typeAccount,
      "numberAccount": numberAccount,
      "email": email,
    };

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final bankAccountResponse = bankAccountFromJson(resp.body);

      return bankAccountResponse;
    } else if (resp.statusCode == 400) {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future getAccountBankByUser(String uid) async {
    final urlFinal = ('${Environment.apiUrl}/api/bank/account/by/user/$uid');

    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final bankAccountResponse = bankAccountFromJson(resp.body);

      return bankAccountResponse;
    } else if (resp.statusCode == 404) {
      final respBody = errorMessageResponseFromJson(resp.body);
      return respBody;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
