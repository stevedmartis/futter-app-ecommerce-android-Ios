import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/store_profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
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
import 'package:universal_platform/universal_platform.dart';

class ContactInfoStore extends StatefulWidget {
  @override
  _ContactInfoStoreState createState() => _ContactInfoStoreState();
}

class _ContactInfoStoreState extends State<ContactInfoStore> {
  final storeProfileBloc = StoreProfileBloc();

  final categoryCtrl = TextEditingController();

  final emailCtl = TextEditingController();
  final numberCtrl = TextEditingController();

  bool isEmailChange = false;
  bool isNumberChange = false;
  bool loading = false;
  Store store;
  @override
  void initState() {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();
    });

    emailCtl.text = store.user.email;
    numberCtrl.text = (store.user.phone == '0') ? '' : store.user.phone;

    emailCtl.addListener(() {
      setState(() {
        if (store.user.email != emailCtl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;
      });
    });

    numberCtrl.addListener(() {
      setState(() {
        if (store.address != numberCtrl.text)
          this.isNumberChange = true;
        else
          this.isNumberChange = false;
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

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthenticationBLoC>(context);

    if (authService.serviceSelect == 1) categoryCtrl.text = 'Restaurante';

    if (authService.serviceSelect == 2)
      categoryCtrl.text = 'Frutería/Verdulería';
    if (authService.serviceSelect == 3)
      categoryCtrl.text = 'Licorería/Botillería';

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
                  ),
                  actions: [
                    (!loading)
                        ? IconButton(
                            color: currentTheme.accentColor,
                            icon: Icon(
                              Icons.check,
                              size: 35,
                            ),
                            onPressed: () {
                              _editProfile();
                            })
                        : buildLoadingWidget(context),
                  ],
                ),
                backgroundColor: Colors.black,
                body: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverFixedExtentList(
                          itemExtent: size.height,
                          delegate: SliverChildListDelegate([
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(children: [
                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Revisa tu información de contacto',
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
                                    'Estas opciones de contacto se mostrarán en tu perfil para que las personas puedan ponerse en contacto contigo. Puedes editarlas o eliminarlas cuando quieras.',
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

                                _createEmail(),
                                _createNumber(),
                              ]),
                            )
                          ]))
                    ]))));
  }

  Widget _createNumber() {
    return StreamBuilder(
      stream: storeProfileBloc.numberStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: numberCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(9),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                prefixIcon: Container(
                  child: (UniversalPlatform.isAndroid)
                      ? Icon(Icons.phone_android, color: Colors.white)
                      : Icon(Icons.phone_iphone, color: Colors.white),
                ),
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
                prefix: Text('+56 ',
                    style: TextStyle(color: currentTheme.accentColor)),
                labelText: 'Número de teléfono de la tienda',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeNumber,
          ),
        );
      },
    );
  }

  Widget _createEmail() {
    return StreamBuilder(
      stream: storeProfileBloc.emailStream,
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
            onChanged: storeProfileBloc.changeEmail,
          ),
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

        Navigator.push(context, profileEditRoute());
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
