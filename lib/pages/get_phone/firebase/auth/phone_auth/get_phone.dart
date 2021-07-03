import 'dart:async';

import 'package:australti_ecommerce_app/pages/get_phone/firebase/auth/phone_auth/verify.dart';
import 'package:australti_ecommerce_app/pages/get_phone/providers/countries.dart';
import 'package:australti_ecommerce_app/pages/get_phone/providers/phone_auth.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

class PhoneAuthGetPhone extends StatefulWidget {
  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  final _blocPhone = PhoneAuthDataProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _blocPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final phoneBloc = Provider.of<PhoneAuthDataProvider>(context);

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
                          'Ingresa Numero celular',
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
                      stream: phoneBloc.numberPhone.stream,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        final phoneNumber = snapshot.data;

                        bool isDisabled = true;
                        (phoneNumber != null)
                            ? (phoneNumber.length < 9)
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
                              controller: phoneBloc.phoneNumberController,
                              keyboardType: TextInputType.number,

                              style: TextStyle(
                                color: (currentTheme.accentColor),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(9),
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
                                  // icon: Icon(Icons.perm_identity),
                                  //  fillColor: currentTheme.accentColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: currentTheme.accentColor,
                                        width: 2.0),
                                  ),
                                  hintText: '',
                                  prefix: Text('+56 ',
                                      style: TextStyle(
                                          color: currentTheme.accentColor)),
                                  labelText: 'Numero celular',
                                  prefixIcon: Container(
                                    child: (UniversalPlatform.isAndroid)
                                        ? Icon(Icons.phone_android,
                                            color: (isDisabled)
                                                ? Colors.grey
                                                : currentTheme.accentColor)
                                        : Icon(Icons.phone_iphone,
                                            color: (isDisabled)
                                                ? Colors.grey
                                                : currentTheme.accentColor),
                                  )

                                  //counterText: snapshot.data,
                                  ),

                              onChanged: (value) => phoneBloc.phoneValue(value),
                            ),
                          ),
                        );
                      },
                    ),

                    Spacer(),
                    StreamBuilder<String>(
                      stream: phoneBloc.numberPhone.stream,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        final phoneNumber = snapshot.data;

                        bool isDisabled = true;
                        (phoneNumber != null)
                            ? (phoneNumber.length < 9)
                                ? isDisabled = true
                                : isDisabled = false
                            : isDisabled = true;

                        return Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!isDisabled) {
                                showModalLoading(context);

                                startPhoneAuth();
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

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: countryProvider.selectedCountry.dialCode,
        onCodeSent: () {
          Timer(
              Duration(seconds: 3),
              () => {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (BuildContext context) => PhoneAuthVerify()))
                  });
        },
        onFailed: () {
          showSnackBar(context, phoneAuthDataProvider.message);
        },
        onError: () {
          showSnackBar(context, phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      showSnackBar(context, "Numero celular invalido");
      return;
    }
  }
}
