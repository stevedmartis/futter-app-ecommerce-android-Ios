import 'package:freeily/responses/payment_intent_response.dart';
import 'package:freeily/responses/stripe_custom_response.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'package:http/http.dart' as http;

class StripeService {
  // Singleton
  StripeService._privateConstructor();
  static final StripeService _intance = StripeService._privateConstructor();
  factory StripeService() => _intance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51JL8aBIRHBOmWg3bQT17BK9UMOabnBOtryeIL7cEtXSouIUgtQqqYdnTrUgZdcn9CSQOANEwaSnBO9m82QUlwBmh00i2aHP2kC';
  static String _apiKey =
      'pk_test_51JL8aBIRHBOmWg3bvf7mJQFp4c163WopNcScUIeBrO2Lbkdr690gyi4YBSonCKrFXlCE7zkoeMGofEUuhVn1lSR9005MfUtNkr';

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: _apiKey, androidPayMode: 'test', merchantId: 'Test'));
  }

  Future<StripeCustomResponse> payWithSelectedCreditCard({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      final resp = await this._makeThePay(
          amount: amount, currency: currency, paymentMethod: paymentMethod);

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<PaymentMethod> payWithNewCreditCard({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      return paymentMethod;
    } catch (e) {
      return PaymentMethod(
          id: '0',
          customerId: (e.message.toString() ==
                      'PlatformException(-, null, null, null)' ||
                  e.message.toString() == 'Cancelled by user')
              ? 'cancel'
              : '');
    }
  }

  Future<StripeCustomResponse> payWithApplePayGooglePay({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;

      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
            totalPrice: amount,
            currencyCode: currency,
          ),
          applePayOptions: ApplePayPaymentOptions(
              countryCode: 'US',
              currencyCode: currency,
              items: [
                ApplePayItem(label: 'Super producto 1', amount: '$newAmount')
              ]));

      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: CreditCard(token: token.tokenId)));

      final resp = await this._makeThePay(
          amount: amount, currency: currency, paymentMethod: paymentMethod);

      await StripePayment.completeNativePayRequest();

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<PaymentIntentResponse> _createPaymentIntent({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final data = {'amount': amount, 'currency': currency};

      final resp =
          await http.post(Uri.parse(_paymentApiUrl), body: data, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${StripeService._secretKey}'
      });

      final resppayintent = paymentIntentResponseFromJson(resp.body);
      return resppayintent;
    } catch (e) {
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _makeThePay(
      {@required String amount,
      @required String currency,
      @required PaymentMethod paymentMethod}) async {
    try {
      // Crear el intent
      final paymentIntent =
          await this._createPaymentIntent(amount: amount, currency: currency);

      final paymentResult = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent.clientSecret,
              paymentMethodId: paymentMethod.id));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
