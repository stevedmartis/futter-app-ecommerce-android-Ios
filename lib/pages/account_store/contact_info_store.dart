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

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

class ContactInfoStore extends StatefulWidget {
  @override
  _ContactInfoStoreState createState() => _ContactInfoStoreState();
}

class _ContactInfoStoreState extends State<ContactInfoStore> {
  final storeProfileBloc = StoreProfileBloc();

  final categoryCtrl = TextEditingController();

  final emailCtl = TextEditingController();

  final instagramCtl = TextEditingController();
  final numberCtrl = TextEditingController();

  final prefs = new AuthUserPreferences();

  bool isEmailChange = false;
  bool isNumberChange = false;
  bool isInstagramChange = false;
  bool loading = false;
  Store store;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    emailCtl.text = store.user.email;
    numberCtrl.text = (store.user.phone == '0') ? '' : store.user.phone;
    instagramCtl.text = store.instagram;

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

    instagramCtl.addListener(() {
      setState(() {
        if (store.instagram != instagramCtl.text)
          this.isInstagramChange = true;
        else
          this.isInstagramChange = false;
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
                  title:
                      _showTitle ? Text('Información de contacto') : Text(''),
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
                            color: currentTheme.primaryColor,
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
                                SizedBox(height: 40),
                                _createEmail(),
                                _createNumber(),

                                _createInstagram(),
                                /* SizedBox(height: 40),

                                Row(
                                  children: [
                                    Container(
                                        child: FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.grey,
                                      size: 30,
                                    )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: size.width / 1.4,
                                      child: Text(
                                        'Con el número de telefono las personas podran ponerse en contacto contigo via Whatsapp.',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ) */
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
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child:
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white)),
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
                labelText: 'Número empresa de la tienda',
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
                prefixIcon: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.email_outlined, color: Colors.white)),
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

  Widget _createInstagram() {
    return StreamBuilder(
      stream: storeProfileBloc.instagramStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: instagramCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                prefixIcon: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.white)),
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
                labelText: 'Usuario de instagram',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeInstagram,
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
    final instagram = instagramCtl.text.trim();
    final editProfileOk = await authService.editInfoContactStoreProfile(
        storeProfile.user.uid, email, phone, instagram);

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
