import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/store_profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';

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
  final storeProfileBloc = StoreProfileBloc();

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

  bool loading = false;
  Store store;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();
    });

    emailCtl.text = store.user.email;
    numberCtrl.text = (store.user.phone == '0') ? '' : store.user.phone;

    nameCtrl.addListener(() {
      setState(() {
        if (store.user.email != nameCtrl.text)
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
        if (store.user.email != rutCtrl.text)
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
        if (store.address != numberCtrl.text)
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
        if (store.user.email != emailCtl.text)
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
    storeProfileBloc.dispose();
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
                            color: (isControllerChange && !errorRequired)
                                ? currentTheme.primaryColor
                                : Colors.grey,
                            icon: Icon(
                              Icons.check,
                              size: 35,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _editProfile();
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
                                    'Ingresa la cuenta bancaria de pagos.',
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
                                    'Esta opcion se mostrarán en el pedido para que las personas puedan depositar con los medio de pago. Puedes editarlas o eliminarlas cuando quieras.',
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
                                Container(
                                  child: TextField(
                                    style: TextStyle(
                                      color: (currentTheme.accentColor),
                                    ),
                                    onTap: () {
                                      showMaterialCupertinoBottomSheetBanks(
                                        context,
                                        () {},
                                        () {},
                                      );
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white54),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white54),
                                      prefixIcon: Icon(Icons.account_balance,
                                          color: Colors.white),
                                      //  fillColor: currentTheme.accentColor,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: currentTheme.accentColor,
                                            width: 2.0),
                                      ),
                                      hintText: '',
                                      labelText: 'Banco de la cuenta',

                                      //counterText: snapshot.data,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _createName(),
                                SizedBox(height: 10),
                                _createRut(),
                                SizedBox(height: 10),
                                _createNumber(),
                                SizedBox(height: 10),
                                _createEmail(),

                                SizedBox(height: 10),
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
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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

  _editProfile() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    setState(() {
      loading = true;
    });

    final storeProfile = store;

    final email = emailCtl.text.trim();
    final phone = numberCtrl.text.trim();

    final editProfileOk = await authService.editInfoContactStoreProfile(
        storeProfile.user.uid, email, phone);

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Información de contacto guardada');

        (authService.isChangeToSale)
            ? Navigator.push(context, displayProfileStoreRoute())
            : Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
        });
        showAlertError(context, 'Error', editProfileOk);
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
