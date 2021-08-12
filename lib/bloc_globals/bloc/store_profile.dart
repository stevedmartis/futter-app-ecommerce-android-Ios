import 'dart:async';
import 'package:australti_ecommerce_app/bloc_globals/bloc/validators.dart';
import 'package:australti_ecommerce_app/models/bank_account.dart';
import 'package:australti_ecommerce_app/responses/bank_account.dart';
import 'package:australti_ecommerce_app/services/bank_Service.dart';
import 'package:rxdart/rxdart.dart';

class StoreProfileBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usernameController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _aboutController = BehaviorSubject<String>();
  final _imageUpdateCtrl = BehaviorSubject<bool>();
  final _categoryController = BehaviorSubject<String>();

  final _numberController = BehaviorSubject<String>();

  final _nameBankController = BehaviorSubject<String>();
  final _numberBankController = BehaviorSubject<String>();
  final _rutBankController = BehaviorSubject<String>();
  final _emailBankController = BehaviorSubject<String>();
  final _timeController = BehaviorSubject<String>();
  final _offController = BehaviorSubject<String>();
  final bankService = BankService();
  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get usernameSteam =>
      _usernameController.stream.transform(validationUserNameRequired);
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get aboutStream => _aboutController.stream;
  Stream<String> get lastNameStream => _lastNameController.stream;

  Stream<String> get categoryStream => _categoryController.stream;

  Stream<String> get numberStream =>
      _numberController.stream.transform(validationNumberPhoneRequired);

  Stream<String> get timeStream =>
      _timeController.stream.transform(validationOk);

  BehaviorSubject<bool> get imageUpdate => _imageUpdateCtrl;

  Stream<String> get offStream => _offController.stream.transform(validationOk);

  Stream<bool> get formValidStream => CombineLatestStream.combine3(
      emailStream, nameStream, usernameSteam, (e, n, u) => true);

  Stream<String> get nameBankStream =>
      _nameBankController.stream.transform(validationNameRequired);

  Stream<String> get numberBankStream =>
      _numberBankController.stream.transform(validationNumberBank);

  Stream<String> get rutBankStream =>
      _rutBankController.stream.transform(validationRutRequired);

  Stream<String> get emailBankStream =>
      _emailBankController.stream.transform(validarEmail);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeUsername => _usernameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeAbout => _aboutController.sink.add;
  Function(String) get changeNumber => _numberController.sink.add;
  Function(String) get changeCategory => _categoryController.sink.add;

  Function(String) get changeNameBank => _nameBankController.sink.add;
  Function(String) get changeNumberBank => _numberBankController.sink.add;
  Function(String) get changeRutBank => _rutBankController.sink.add;

  Function(String) get changeEmailBank => _emailBankController.sink.add;
  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get username => _usernameController.value;
  String get name => _nameController.value;
  String get lastName => _lastNameController.value;

  String get category => _categoryController.value;

  String get about => _aboutController.value;

  final BehaviorSubject<List<Bank>> _banksResult =
      BehaviorSubject<List<Bank>>();

  BehaviorSubject<List<Bank>> get banksResults => _banksResult;

  final BehaviorSubject<Bank> _banksSelected = BehaviorSubject<Bank>();

  final BehaviorSubject<BankAccount> _bankAccount =
      BehaviorSubject<BankAccount>();

  set setBankSelected(Bank bank) {
    _banksSelected.sink.add(bank);
  }

  set setBankAccount(BankAccount bank) {
    _bankAccount.sink.add(bank);
  }

  BehaviorSubject<BankAccount> get bankAccount => _bankAccount;

  BehaviorSubject<Bank> get bankSelected => _banksSelected;
  searchBanks(String searchTerm) async {
    final resp = await bankService.getBanks(searchTerm);

    if (!_banksResult.isClosed) _banksResult.sink.add(resp);
  }

  dispose() {
    _imageUpdateCtrl?.close();
    _emailController?.close();
    _categoryController?.close();
    _passwordController?.close();
    _usernameController?.close();
    _nameController?.close();
    _numberController?.close();
    _lastNameController?.close();
    _aboutController?.close();
    _offController?.close();
    _timeController?.close();

    _banksResult?.close();
    _nameBankController?.close();
    _numberBankController?.close();
    _rutBankController?.close();
    _emailBankController?.close();
  }

  disposeBankSelected() {
    _banksSelected?.close();
    _bankAccount?.close();
  }
}

final storeProfileBloc = StoreProfileBloc();
