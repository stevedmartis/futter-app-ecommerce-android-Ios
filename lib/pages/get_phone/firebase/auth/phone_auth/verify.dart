import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/pages/get_phone/providers/phone_auth.dart';
import 'package:australti_ecommerce_app/pages/get_phone/utils/constants.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  final Color cardBackgroundColor = Color(0xFFFCA967);
  final String logo = Assets.firebase;
  final String appName = "Awesome app";

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final phoneAuthDataProvider = Provider.of<PhoneAuthDataProvider>(context);
    final size = MediaQuery.of(context).size;

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                color: currentTheme.accentColor,
                icon: Icon(
                  Icons.chevron_left,
                  size: 40,
                ),
                onPressed: () => Navigator.pop(context),
              )),
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width,
                        child: Text(
                          'Ingresa Codigo Verificación',
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),

                    // email

                    StreamBuilder<String>(
                      stream: phoneAuthDataProvider.codeOtp.stream,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        final codeOtp = snapshot.data;

                        bool isDisabled = true;
                        (codeOtp != null)
                            ? (codeOtp.length < 9)
                                ? isDisabled = true
                                : isDisabled = false
                            : isDisabled = true;

                        return Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: TextField(
                              // onEditingComplete: _node.nextFocus,
                              controller:
                                  phoneAuthDataProvider.codeOtpController,
                              keyboardType: TextInputType.number,

                              style: TextStyle(
                                color: (currentTheme.accentColor),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(6),
                              ],
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white54,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white54,
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: currentTheme.accentColor,
                                      width: 2.0),
                                ),
                                hintText: '',
                                labelText: 'Codigo enviado',

                                //counterText: snapshot.data,
                              ),

                              onChanged: (value) =>
                                  phoneAuthDataProvider.codeValue(value),
                            ),
                          ),
                        );
                      },
                    ),

                    Spacer(),
                    StreamBuilder<String>(
                      stream: phoneAuthDataProvider.codeOtp.stream,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        final codeOtp = snapshot.data;

                        bool isDisabled = true;
                        (codeOtp != null)
                            ? (codeOtp.length < 6)
                                ? isDisabled = true
                                : isDisabled = false
                            : isDisabled = true;

                        return Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!isDisabled) {
                                showModalLoading(context);
                                signIn(codeOtp);
                              } else {
                                return false;
                              }
                            },
                            child: Container(
                              child: Center(
                                child: confirmButton(
                                    'Continuar',
                                    [
                                      currentTheme.primaryColor,
                                      Color(0xff3AFF3E),
                                      Color(0xff42FF00),
                                      currentTheme.primaryColor,
                                    ],
                                    loading,
                                    !isDisabled),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // password

                    // submit
                  ],
                )),
          )),
    ));
  }

  signIn(String code) {
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  onStarted() {
    showSnackBar(context, "Verificado con exito");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    //  showSnackBar(context, "Codigo enviado");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    showSnackBar(context, "Codigo reenviado");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    showSnackBar(context, "Verificado con exito");
    await Future.delayed(Duration(seconds: 1));
    _signinWithPhone(context);
  }

  onFailed() {
//    _showSnackBar(phoneAuthDataProvider.message);
    showSnackBar(context, "Error, Intente mas tarde");
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    showSnackBar(context,
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    showSnackBar(context, "Error, Intente mas tarde");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  _signinWithPhone(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    final signInAppleOk = await authService.signInWithPhone(
      phoneAuthDataProvider.numberPhone.value,
      phoneAuthDataProvider.actualCode,
    );

    if (signInAppleOk) {
      socketService.connect();

      if (authService.redirect == 'profile' &&
          authService.storeAuth.user.first) {
        Navigator.push(context, profileEditRoute());
      } else if (authService.redirect == 'vender' &&
          authService.storeAuth.user.first) {
        Navigator.push(context, profileEditRoute());
      }

      if (!authService.storeAuth.user.first) {
        Provider.of<MenuModel>(context, listen: false).currentPage = 0;
        Navigator.push(context, principalHomeRoute());
      }

      //Navigator.push(context, profileAuthRoute(true));
    } else {
      // Mostara alerta
      showAlertError(context, 'Error', 'Intente más tarde');
    }

    //Navigator.pushReplacementNamed(context, '');
  }
}
