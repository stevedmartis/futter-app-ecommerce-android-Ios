import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/bloc/store_profile.dart';

import 'package:freeily/models/store.dart';
import 'package:freeily/preferences/user_preferences.dart';

import 'package:freeily/store_principal/store_principal_bloc.dart';

import 'package:freeily/theme/theme.dart';

import 'package:freeily/widgets/modal_bottom_sheet.dart';
import 'package:freeily/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class BankAccountStorePayment extends StatefulWidget {
  BankAccountStorePayment({this.fromOrder = false});
  final bool fromOrder;
  @override
  _BankAccountStoreState createState() => _BankAccountStoreState();
}

class _BankAccountStoreState extends State<BankAccountStorePayment> {
  final bankCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final rutCtrl = TextEditingController();
  final typeAccountCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final emailCtl = TextEditingController();
  final prefs = new AuthUserPreferences();

  bool isNameChange = false;
  bool isRutChange = false;
  bool typeAccount = false;
  bool isNumberChange = false;
  bool isBankChange = false;
  bool isEmailChange = false;
  bool errorRequired = false;
  bool isEdit = false;
  bool loading = false;
  Store store;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);
    store = authService.storeAuth;
    final bankFind = storeProfileBloc.banksResults.value.firstWhere(
        (item) => item.id == storeBloc.currentBankAccount.bankOfAccount,
        orElse: () => null);

    if (bankFind != null) {
      bankCtrl.text = bankFind.nameBank;
      rutCtrl.text = storeBloc.currentBankAccount.rutAccount;
      numberCtrl.text = storeBloc.currentBankAccount.numberAccount;
      emailCtl.text = storeBloc.currentBankAccount.emailAccount;
      nameCtrl.text = storeBloc.currentBankAccount.nameAccount;
      setState(() {
        isEdit = true;
      });
    } else {
      emailCtl.text = store.user.email;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openSheetBottom() {
    showSelectServiceMaterialCupertinoBottomSheet(context);
  }

  ScrollController _scrollController;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
                appBar: AppBar(
                  title: _showTitle ? Text('Cuenta bancaria') : Text(''),
                  backgroundColor: currentTheme.scaffoldBackgroundColor,
                  leading: IconButton(
                    color: currentTheme.primaryColor,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 40,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                body: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverFixedExtentList(
                          itemExtent: size.height,
                          delegate: SliverChildListDelegate([
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(children: [
                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Datos para transferencia.',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Realiza el pago desde tu banco con estos datos, la tienda confirmara el deposito cuando prepare tu pedido.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // email

                                _createBank(),

                                SizedBox(height: 10),
                                GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "${nameCtrl.text}"));

                                      showSnackBar(context,
                                          'Nombre copiado en portapapeles');
                                    },
                                    child: _createName()),
                                SizedBox(height: 10),
                                GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "${rutCtrl.text}"));

                                      showSnackBar(context,
                                          'Rut copiado en portapapeles');
                                    },
                                    child: _createRut()),
                                SizedBox(height: 10),
                                GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "${numberCtrl.text}"));

                                      showSnackBar(context,
                                          'Numero copiado en portapapeles');
                                    },
                                    child: _createNumber()),
                                SizedBox(height: 10),
                                GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "${emailCtl.text}"));

                                      showSnackBar(context,
                                          'Email copiado en portapapeles');
                                    },
                                    child: _createEmail()),

                                SizedBox(height: 20),

                                Container(
                                    height: 50,
                                    width: size.width / 1.1,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          HapticFeedback.lightImpact();

                                          if (widget.fromOrder) {
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5.0,
                                          fixedSize: Size.fromWidth(size.width),
                                          primary: currentTheme.primaryColor,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: Text('Volver al pedido')))
                              ]),
                            )
                          ]))
                    ]))));
  }

  Widget _createBank() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      child: TextField(
        enabled: false,
        controller: bankCtrl,
        style: TextStyle(
          color: (currentTheme.primaryColor),
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.account_balance,
              color: (bankCtrl.text != '')
                  ? currentTheme.primaryColor
                  : Colors.white),
          //  fillColor: currentTheme.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: currentTheme.primaryColor, width: 2.0),
          ),
          hintText: '',
          labelText: 'Banco de la cuenta',

          //counterText: snapshot.data,
        ),
      ),
    );
  }

  Widget _createName() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          enabled: false,
          style: TextStyle(color: Colors.white),
          controller: nameCtrl,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(50),
          ],
          keyboardType: TextInputType.text,
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
            suffixIcon: Icon(Icons.content_copy),
            //  fillColor: currentTheme.primaryColor,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: currentTheme.primaryColor, width: 2.0),
            ),
            hintText: '',
            labelText: 'Nombre del titular',
            //counterText: snapshot.data,
          ),
        ));
  }

  Widget _createNumber() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        enabled: false,
        style: TextStyle(color: Colors.white),
        controller: numberCtrl,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(20),
        ],
        keyboardType: TextInputType.number,
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
          suffixIcon: Icon(Icons.content_copy),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: currentTheme.primaryColor, width: 2.0),
          ),
          hintText: '',
          labelText: 'Número de cuenta',
          //counterText: snapshot.data,
        ),
      ),
    );
  }

  Widget _createRut() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          enabled: false,
          style: TextStyle(color: Colors.white),
          controller: rutCtrl,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(9),
          ],
          keyboardType: TextInputType.number,
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
            suffixIcon: Icon(Icons.content_copy),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: currentTheme.primaryColor, width: 2.0),
            ),
            hintText: '',
            labelText: 'Rut del titular',
            //counterText: snapshot.data,
          ),
        ));
  }

  Widget _createEmail() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: TextField(
            enabled: false,
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: emailCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelStyle: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54,
              ),
              suffixIcon: Icon(Icons.content_copy),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: currentTheme.currentTheme.primaryColor,
                ),
              ),
              hintText: '',
              labelText: 'Correo electrónico de la tienda',
              //counterText: snapshot.data,
            )));
  }
}
