import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/store_profile.dart';
import 'package:australti_ecommerce_app/models/bank_account.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/bank_Service.dart';

import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/modal_bottom_sheet.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class BankAccountStore extends StatefulWidget {
  @override
  _BankAccountStoreState createState() => _BankAccountStoreState();
}

class _BankAccountStoreState extends State<BankAccountStore> {
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
    store = authService.storeAuth;
    final bankFind = storeProfileBloc.banksResults.value.firstWhere(
        (item) => item.id == storeProfileBloc.bankAccount.value.bankOfAccount,
        orElse: () => null);

    if (bankFind != null) {
      nameCtrl.text = storeProfileBloc.bankAccount.value.nameAccount;
      rutCtrl.text = storeProfileBloc.bankAccount.value.rutAccount;
      numberCtrl.text = storeProfileBloc.bankAccount.value.numberAccount;
      emailCtl.text = storeProfileBloc.bankAccount.value.emailAccount;

      setState(() {
        isEdit = true;
      });
    } else {
      emailCtl.text = store.user.email;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();
    });

    nameCtrl.addListener(() {
      setState(() {
        if (storeProfileBloc.bankAccount.value.nameAccount != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;

        if (nameCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });

    rutCtrl.addListener(() {
      setState(() {
        if (storeProfileBloc.bankAccount.value.rutAccount != rutCtrl.text)
          this.isRutChange = true;
        else
          this.isRutChange = false;

        if (rutCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });

    numberCtrl.addListener(() {
      setState(() {
        if (storeProfileBloc.bankAccount.value.numberAccount != numberCtrl.text)
          this.isNumberChange = true;
        else
          this.isNumberChange = false;

        if (numberCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });

    emailCtl.addListener(() {
      setState(() {
        if (storeProfileBloc.bankAccount.value.emailAccount != emailCtl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;

        if (emailCtl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });

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
    final isControllerChange = isNameChange && isRutChange && isNumberChange;

    final authService = Provider.of<AuthenticationBLoC>(context);

    final isControllerChangeEdit =
        isNameChange || isRutChange || isNumberChange || isEmailChange;

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
                  actions: [
                    (!loading)
                        ? IconButton(
                            color: ((isEdit)
                                    ? isControllerChangeEdit && !errorRequired
                                    : isControllerChange && !errorRequired)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                            icon: Icon(
                              Icons.check,
                              size: 35,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();

                              (isEdit)
                                  ? _editAccountBank()
                                  : _createAccountBank();
                            })
                        : buildLoadingWidget(context),
                  ],
                ),
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                body: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverFixedExtentList(
                          itemExtent: size.height * 1.1,
                          delegate: SliverChildListDelegate([
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(children: [
                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Ingresa cuenta bancaria de pagos.',
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
                                    'Esta opción se mostrará en medios de pago para que las personas puedan pagarte y/o recibir depositos. Puedes editarla o eliminarla cuando quieras.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // email

                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Información pública de la tienda',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),

                                _createBank(),

                                SizedBox(height: 10),
                                _createName(),
                                SizedBox(height: 10),
                                _createRut(),
                                SizedBox(height: 10),
                                _createNumber(),
                                SizedBox(height: 10),
                                _createEmail(),

                                SizedBox(height: 30),

                                GestureDetector(
                                  onTap: () {
                                    (authService.isChangeToSale)
                                        ? Navigator.push(
                                            context, profileEditRoute())
                                        : Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Omitir este paso',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: Text(
                                    '* Si omites este paso, el metodo de pago para tus clientes sera solo en efectivo.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ]))
                    ]))));
  }

  Widget _createBank() {
    return StreamBuilder(
      stream: storeProfileBloc.bankSelected,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        Bank bank = snapshot.data;

        bankCtrl.text = (bank != null) ? bank.nameBank : '';

        return Container(
          child: TextField(
            controller: bankCtrl,
            style: TextStyle(
              color: (currentTheme.accentColor),
            ),
            onTap: () {
              showMaterialCupertinoBottomSheetBanks(
                context,
                () {},
                () {},
              );
              FocusScope.of(context).requestFocus(new FocusNode());
            },
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
                      ? currentTheme.accentColor
                      : Colors.white),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: currentTheme.accentColor, width: 2.0),
              ),
              hintText: '',
              labelText: 'Banco de la cuenta',

              //counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }

  Widget _createName() {
    return StreamBuilder(
      stream: storeProfileBloc.nameBankStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
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
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Nombre del titular',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeNameBank,
          ),
        );
      },
    );
  }

  Widget _createNumber() {
    return StreamBuilder(
      stream: storeProfileBloc.numberBankStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
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
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Número de cuenta',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeNumberBank,
          ),
        );
      },
    );
  }

  Widget _createRut() {
    return StreamBuilder(
      stream: storeProfileBloc.rutBankStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
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
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Rut del titular',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeRutBank,
          ),
        );
      },
    );
  }

  Widget _createEmail() {
    return StreamBuilder(
      stream: storeProfileBloc.emailBankStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextField(
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
                  // icon: Icon(Icons.perm_identity),
                  //  fillColor: currentTheme.accentColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor,
                    ),
                  ),
                  hintText: '',
                  labelText: 'Correo electrónico de la tienda',
                  //counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: storeProfileBloc.changeEmailBank),
        );
      },
    );
  }

  _createAccountBank() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final bankService = Provider.of<BankService>(context, listen: false);
    setState(() {
      loading = true;
    });

    final storeProfile = store;

    final bankId = storeProfileBloc.bankSelected.value.id.trim();
    final name = nameCtrl.text.trim();
    final rut = rutCtrl.text.trim();
    final typeAccount = typeAccountCtrl.text.trim();
    final numberAccount = numberCtrl.text.trim();
    final email = emailCtl.text.trim();

    final createAccountBank = await bankService.createAccountBank(
        storeProfile.user.uid,
        bankId,
        name,
        rut,
        typeAccount,
        numberAccount,
        email);

    if (createAccountBank != null) {
      if (createAccountBank.ok) {
        setState(() {
          loading = false;
        });

        storeProfileBloc.setBankAccount = createAccountBank.bankAccount;

        showSnackBar(context, 'Cuenta bancaria guardada');

        (authService.isChangeToSale)
            ? Navigator.push(context, displayProfileStoreRoute())
            : Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
        });
        showAlertError(context, 'Error', createAccountBank);
      }
    } else {
      setState(() {
        loading = false;
      });
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }

  _editAccountBank() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final bankService = Provider.of<BankService>(context, listen: false);
    setState(() {
      loading = true;
    });

    final bankId = storeProfileBloc.bankSelected.value.id.trim();
    final name = nameCtrl.text.trim();
    final rut = rutCtrl.text.trim();
    final typeAccount = typeAccountCtrl.text.trim();
    final numberAccount = numberCtrl.text.trim();
    final email = emailCtl.text.trim();

    final editAccountBank = await bankService.editAccountBank(
        storeProfileBloc.bankAccount.value.id,
        bankId,
        name,
        rut,
        typeAccount,
        numberAccount,
        email);

    if (editAccountBank != null) {
      if (editAccountBank.ok) {
        setState(() {
          loading = false;
        });

        storeProfileBloc.setBankAccount = editAccountBank.bankAccount;

        showSnackBar(context, 'Cuenta bancaria editada');

        (authService.isChangeToSale)
            ? Navigator.push(context, displayProfileStoreRoute())
            : Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
        });
        showAlertError(context, 'Error', editAccountBank);
      }
    } else {
      setState(() {
        loading = false;
      });
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }
}
