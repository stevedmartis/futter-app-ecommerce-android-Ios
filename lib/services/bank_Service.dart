import 'package:australti_ecommerce_app/models/bank_account.dart';
import 'package:flutter/material.dart';

class BankService with ChangeNotifier {
  List<Bank> banks = [
    Bank(
      id: '0',
      nameBank: 'Banco de chile / Edwards-CITI',
    ),
    Bank(
      id: '1',
      nameBank: 'Banco Estado',
    ),
    Bank(
      id: '2',
      nameBank: 'ScotiaBank',
    ),
    Bank(
      id: '3',
      nameBank: 'Banco de Creditos e Inversiones',
    ),
    Bank(
      id: '3',
      nameBank: 'CoprBanca',
    ),
    Bank(
      id: '4',
      nameBank: 'Banco Bice',
    ),
    Bank(
      id: '5',
      nameBank: 'HSBC Bank',
    ),
    Bank(
      id: '6',
      nameBank: 'Banco Santander',
    ),
    Bank(
      id: '7',
      nameBank: 'Banco Itaú',
    ),
    Bank(
      id: '8',
      nameBank: 'Banco Security',
    ),
    Bank(
      id: '9',
      nameBank: 'Banco BBVA',
    ),
    Bank(
      id: '10',
      nameBank: 'Banco del Desarrollo',
    ),
    Bank(
      id: '11',
      nameBank: 'Banco Falabella',
    ),
    Bank(
      id: '12',
      nameBank: 'Banco Ripley',
    ),
    Bank(
      id: '13',
      nameBank: 'Rabo Bank',
    ),
    Bank(
      id: '14',
      nameBank: 'Banco Consorcio',
    ),
    Bank(
      id: '14',
      nameBank: 'Banco Paris',
    )
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

    //value not exists
  }
}
