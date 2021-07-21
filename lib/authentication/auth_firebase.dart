import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthBLoC with ChangeNotifier {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Null> handleSignInMobile(String mobileNumber) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verificationCompleted = (user) {
      return user;
    };

    print("verificationCompleted: + $verificationCompleted");

    final PhoneVerificationFailed verificationFailed = (exception) {
      print("${exception.message}");

      return exception;
    };

    print("verificationFailed: + $verificationFailed");

    final PhoneCodeAutoRetrievalTimeout retrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;

      return verificationId;
    };

    print("retrievalTimeout: + $retrievalTimeout");

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobileNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOTPSent,
          codeAutoRetrievalTimeout: retrievalTimeout);
    } catch (onError) {
      print("${onError.message}");
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Done'),
                onPressed: () {},
              )
            ],
          );
        });
  }
}
