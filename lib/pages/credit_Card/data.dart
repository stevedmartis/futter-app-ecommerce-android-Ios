import 'package:australti_ecommerce_app/models/credit_Card.dart';

final List<CreditCard> tarjetas = <CreditCard>[
  CreditCard(
      id: '0',
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvv: '213',
      expiracyDate: '01/25',
      cardHolderName: 'Dabi Marz',
      isSelect: false),
  CreditCard(
      id: '1',
      cardNumberHidden: '5555',
      cardNumber: '5555555555554444',
      brand: 'mastercard',
      cvv: '213',
      expiracyDate: '01/25',
      cardHolderName: 'Pekas Marz',
      isSelect: true),
  CreditCard(
      id: '2',
      cardNumberHidden: '3782',
      cardNumber: '378282246310005',
      brand: 'american express',
      cvv: '2134',
      expiracyDate: '01/25',
      cardHolderName: 'Gabo Elias',
      isSelect: false),
];
