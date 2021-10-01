import 'package:freeily/pages/get_phone/firebase/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, VoidCallback;
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';

enum PhoneAuthState {
  Started,
  CodeSent,
  CodeResent,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut
}

class PhoneAuthDataProvider with ChangeNotifier {
  VoidCallback onStarted,
      onCodeSent,
      onCodeResent,
      onVerified,
      onFailed,
      onError,
      onAutoRetrievalTimeout;

  bool _loading = false;

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _codeOtpController = TextEditingController();

  PhoneAuthState _status;
  var _authCredential;
  String _actualCode;
  String _phone, _message;

  final BehaviorSubject<String> _numberPhone = BehaviorSubject<String>();

  final BehaviorSubject<String> _codeOtp = BehaviorSubject<String>();

  setMethods(
      {VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      VoidCallback onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;
  }

  Future<bool> instantiate(
      {String dialCode,
      VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      VoidCallback onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) async {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;

    if (phoneNumberController.text.length < 7) {
      return false;
    }
    phone = '+56' + phoneNumberController.text;

    _startAuth();
    return true;
  }

  _startAuth() {
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      actualCode = verificationId;
      _addStatusMessage("\nEnter the code sent to " + phone);
      _addStatus(PhoneAuthState.CodeSent);
      if (onCodeSent != null) onCodeSent();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      actualCode = verificationId;
      _addStatusMessage("\nAuto retrieval time out");
      _addStatus(PhoneAuthState.AutoRetrievalTimeOut);
      if (onAutoRetrievalTimeout != null) onAutoRetrievalTimeout();
    };

    final PhoneVerificationFailed verificationFailed = (authException) {
      _addStatusMessage('${authException.message}');
      _addStatus(PhoneAuthState.Failed);
      if (onFailed != null) onFailed();
      if (authException.message.contains('not authorized'))
        _addStatusMessage('App not authroized');
      else if (authException.message.contains('Network'))
        _addStatusMessage(
            'Please check your internet connection and try again');
      else
        _addStatusMessage('Something has gone wrong, please try later ' +
            authException.message);
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      _addStatusMessage('Auto retrieving verification code');

      FireBase.auth.signInWithCredential(auth).then((value) {
        if (value.user != null) {
          _addStatusMessage('Authentication successful');
          _addStatus(PhoneAuthState.Verified);
          if (onVerified != null) onVerified();
        } else {
          if (onFailed != null) onFailed();
          _addStatus(PhoneAuthState.Failed);
          _addStatusMessage('Invalid code/invalid authentication');
        }
      }).catchError((error) {
        if (onError != null) onError();
        _addStatus(PhoneAuthState.Error);
        _addStatusMessage('Something has gone wrong, please try later $error');
      });
    };

    if (UniversalPlatform.isWeb)
      FireBase.auth
          .signInWithPhoneNumber(
        phone.toString(),
      )
          .then((value) {
        if (onCodeSent != null) onCodeSent();
        _addStatus(PhoneAuthState.CodeSent);
        _addStatusMessage('Code enviado!');
      }).catchError((error) {
        print(error.toString());
        if (error.code == 'too-many-requests') {
          _addStatusMessage(
              'Demaciados intentos incorrectos, por favor intenta mas tarde.');
          _addStatus(PhoneAuthState.Error);
          onError();
        }

        // _addStatusMessage(error.toString());
      });

    if (!UniversalPlatform.isWeb)
      FireBase.auth
          .verifyPhoneNumber(
              phoneNumber: phone.toString(),
              timeout: Duration(seconds: 60),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) {
        if (onCodeSent != null) onCodeSent();
        _addStatus(PhoneAuthState.CodeSent);
        _addStatusMessage('Code enviado!');
      }).catchError((error) {
        _addStatus(PhoneAuthState.Error);
        _addStatusMessage(error.toString());
        if (onError != null) onError();
      });
  }

  void verifyOTPAndLogin({String smsCode}) async {
    _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    if (UniversalPlatform.isWeb) {
      ConfirmationResult confirmationResult = await FireBase.auth
          .signInWithPhoneNumber('+56' + _phoneNumberController.text);

      try {
        final response = await confirmationResult.confirm(smsCode);

        if (response != null) {
          _addStatusMessage('Verificado con exito');
          _addStatus(PhoneAuthState.Verified);
          onVerified();
        }
      } catch (e) {
        if (e.code == 'invalid-verification-code') {
          _addStatusMessage(
              'Codigo incorrecto, Por favor ingrese codigo en mensaje SMS enviado');
          _addStatus(PhoneAuthState.Error);
          onError();
        } else {
          _addStatusMessage(
              'Error, Por favor ingrese codigo en mensaje SMS enviado');
          _addStatus(PhoneAuthState.Error);
        }
      }
    }

    if (!UniversalPlatform.isWeb)
      FireBase.auth.signInWithCredential(_authCredential).then((result) async {
        _addStatusMessage('Verificado con exito');
        _addStatus(PhoneAuthState.Verified);
        if (onVerified != null) onVerified();
      }).catchError((error) {
        if (onError != null) onError();
        _addStatus(PhoneAuthState.Error);
        _addStatusMessage(
            'Demaciados intentos incorrectos, Por favor intenta más tarde.  $error');
      });
  }

  _addStatus(PhoneAuthState state) {
    status = state;
  }

  void _addStatusMessage(String s) {
    message = s;
  }

  get authCredential => _authCredential;

  set authCredential(value) {
    _authCredential = value;
    notifyListeners();
  }

  get actualCode => _actualCode;

  set actualCode(String value) {
    _actualCode = value;
    notifyListeners();
  }

  get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  phoneValue(String value) async {
    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _numberPhone.sink.add(value);

    notifyListeners();
  }

  BehaviorSubject<String> get numberPhone => _numberPhone;

  codeValue(String value) async {
    // final resp2 = await placeService.getAutocompleteDetails(searchTerm);

    _codeOtp.sink.add(value);

    notifyListeners();
  }

  BehaviorSubject<String> get codeOtp => _codeOtp;

  get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  PhoneAuthState get status => _status;

  set status(PhoneAuthState value) {
    _status = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  @override
  dispose() {
    _numberPhone.close();
    _phoneNumberController.dispose();
    _codeOtp.close();
    _phoneNumberController.text = "";
    _codeOtpController.dispose();
    _codeOtpController.text = "";
    super.dispose();
  }

  TextEditingController get phoneNumberController => _phoneNumberController;

  TextEditingController get codeOtpController => _codeOtpController;
}
