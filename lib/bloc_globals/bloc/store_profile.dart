import 'dart:async';
import 'package:australti_ecommerce_app/bloc_globals/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class StoreProfileBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usernameController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _aboutController = BehaviorSubject<String>();
  final _imageUpdateCtrl = BehaviorSubject<bool>();

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

  BehaviorSubject<bool> get imageUpdate => _imageUpdateCtrl;

  Stream<bool> get formValidStream => CombineLatestStream.combine3(
      emailStream, nameStream, usernameSteam, (e, n, u) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeUsername => _usernameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeAbout => _aboutController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get username => _usernameController.value;
  String get name => _nameController.value;
  String get lastName => _lastNameController.value;

  String get about => _aboutController.value;

  dispose() {
    _imageUpdateCtrl?.close();
    _emailController?.close();
    _passwordController?.close();
    _usernameController?.close();
    _nameController?.close();
    _lastNameController?.close();
    _aboutController?.close();
  }
}

final storeProfileBloc = StoreProfileBloc();
