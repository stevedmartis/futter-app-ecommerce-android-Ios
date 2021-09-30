import 'dart:convert';

import 'package:freeily/global/enviroments.dart';
import 'package:freeily/models/credit_Card.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/responses/credit_card_response.dart';
import 'package:freeily/responses/credit_cards_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

class CreditCardServices with ChangeNotifier {
  List<CreditCard> myCards = [];

  final _storage = new FlutterSecureStorage();

  Future<String> getTokenPlatform() async {
    String token = '';
    (UniversalPlatform.isWeb)
        ? token = prefs.token
        : token = await this._storage.read(key: 'token');

    return token;
  }

  final prefs = new AuthUserPreferences();

  final BehaviorSubject<CreditCard> _cardSelectToPay =
      BehaviorSubject<CreditCard>();

  changeCardSelectToPay(CreditCard card) async {
    _cardSelectToPay.sink.add(card);
  }

  addNewCard(CreditCard card) {
    myCards.add(card);
    notifyListeners();
  }

  BehaviorSubject<CreditCard> get cardselectedToPay => _cardSelectToPay;

  Future getMyCreditCards(String uid) async {
    // this.authenticated = true;

    final String token = await getTokenPlatform();

    final urlFinal =
        ('${Environment.apiUrl}/api/credit-card/my-credit-cards/user/$uid');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final cardsResponse = creditCardsFromJson(resp.body);

      myCards = cardsResponse.cards;

      if (myCards.length > 0) {
        /*  CreditCard cardSelect =
            cardsResponse.cards.firstWhere((item) => item.isSelect);
 */
        changeCardSelectToPay(CreditCard(id: '0'));
        notifyListeners();
      } else {
        changeCardSelectToPay(null);
      }
      return cardsResponse;
    } else {
      // final respBody = errorMessageResponseFromJson(resp.body);

      return false;
    }
  }

  Future getMyCreditCardsStore(String uid) async {
    // this.authenticated = true;

    final token = await getTokenPlatform();

    final urlFinal = ('${Environment.apiUrl}/api/order/orders/by/store/$uid');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      //final cardResponse = creditCardsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

//changeCardSelectToPay(cardSelect)
      return false;
    } else {
      //  final respBody = errorMessageResponseFromJson(resp.body);

      return false;
    }
  }

  Future<CreditCardResponse> createNewCreditCard(
      String userId, String paymentMethodId) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/credit-card/create');

    final data = {"userId": userId, "payment_method_id": paymentMethodId};
    final token = await getTokenPlatform();

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final cardResponse = cardResponseFromJson(resp.body);

      return cardResponse;
    } else {
      final respBody = CreditCardResponse(ok: false);

      return respBody;
    }
  }

  @override
  void dispose() {
    _cardSelectToPay.close();
    super.dispose();
  }
}

final productsFavoritesList = CreditCardServices();
