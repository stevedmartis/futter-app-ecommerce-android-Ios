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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

class DisplayProfileStore extends StatefulWidget {
  @override
  _DisplayProfileStoreState createState() => _DisplayProfileStoreState();
}

class _DisplayProfileStoreState extends State<DisplayProfileStore> {
  final storeProfileBloc = StoreProfileBloc();

  final categoryCtrl = TextEditingController();

  final offCtl = TextEditingController();
  final minTimeDeliveryCtrl = TextEditingController();
  final maxTimeDeliveryCtrl = TextEditingController();

  final prefs = new AuthUserPreferences();

  bool isEmailChange = false;
  bool isNumberChange = false;
  bool loading = false;
  Store store;

  bool isSwitched = false;

  bool isSwitchChange = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();
    });

    isSwitchChange = store.visibility;

    final getTimeMin = store.timeDelivery.toString().split("-").first;

    final getTimeMax = store.timeDelivery.toString().split("-").last;

    print(getTimeMax);
    offCtl.text = (store.percentOff == 0) ? '' : store.percentOff.toString();

    minTimeDeliveryCtrl.text = (getTimeMin == '0') ? '' : getTimeMin.trim();

    maxTimeDeliveryCtrl.text = (getTimeMax == '0') ? '' : getTimeMax.trim();

    offCtl.addListener(() {
      setState(() {
        if (store.user.email != offCtl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;
      });
    });

    minTimeDeliveryCtrl.addListener(() {
      setState(() {
        if (store.address != minTimeDeliveryCtrl.text)
          this.isNumberChange = true;
        else
          this.isNumberChange = false;
      });
    });

    maxTimeDeliveryCtrl.addListener(() {
      setState(() {
        if (store.address != maxTimeDeliveryCtrl.text)
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

  ScrollController _scrollController;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthenticationBLoC>(context);

    return SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
                appBar: AppBar(
                  title:
                      _showTitle ? Text('Visualización de perfil') : Text(''),
                  backgroundColor: currentTheme.scaffoldBackgroundColor,
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
                                    'Visualización de perfil',
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
                                    'Estas opciones de visualización se mostrarán en tu perfil. Puedes editarlas o eliminarlas cuando quieras.',
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

                                SizedBox(height: 10),

                                _createSwitch(),
                                SizedBox(height: 10),

                                _createOff(),
                                SizedBox(height: 20),

                                Container(
                                  width: size.width,
                                  child: Text(
                                    'Tiempo de entrega: ',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    _createMinTimeDelivery(),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(' - ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    _createMaxTimeDelivery()
                                  ],
                                )
                              ]),
                            )
                          ]))
                    ]))));
  }

  Widget _createSwitch() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        child: ListTile(
      //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
      title: Text(
        'Mostrar al publico',
        style: TextStyle(color: Colors.white54),
      ),
      trailing: Switch.adaptive(
        activeColor: currentTheme.currentTheme.accentColor,
        value: isSwitchChange,
        onChanged: (value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            isSwitchChange = value;
            isSwitched = value;
          });
        },
      ),
    ));
  }

  Widget _createMinTimeDelivery() {
    return StreamBuilder(
      stream: storeProfileBloc.timeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
        final size = MediaQuery.of(context).size;

        return Container(
          width: size.width / 2.6,
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: minTimeDeliveryCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
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
                labelText: 'Minimo',
                suffix: Text('Mins'),
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeNumber,
          ),
        );
      },
    );
  }

  Widget _createMaxTimeDelivery() {
    return StreamBuilder(
      stream: storeProfileBloc.timeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
        final size = MediaQuery.of(context).size;

        return Container(
          width: size.width / 2.6,
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: maxTimeDeliveryCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                /*  prefixIcon: Container(
                  child: Icon(Icons.timelapse, color: Colors.white),
                ), */
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
                suffix: Text('Mins'),
                labelText: 'Maximo',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeNumber,
          ),
        );
      },
    );
  }

  Widget _createOff() {
    return StreamBuilder(
      stream: storeProfileBloc.offStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: offCtl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                prefixIcon: Container(
                  margin: EdgeInsets.only(top: 15, left: 15),
                  child: FaIcon(FontAwesomeIcons.percent,
                      color: Colors.white, size: 16),
                ),
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
                labelText: 'Descuento',
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

    final offText = offCtl.text.trim();

    final off = (offText == '') ? 0 : int.parse(offText);
    final minTime = minTimeDeliveryCtrl.text.trim();
    final maxTime = maxTimeDeliveryCtrl.text.trim();

    final timeDelivery = '$minTime - $maxTime';

    final editProfileOk = await authService.editDisplayStoreProfile(
      storeProfile.user.uid,
      isSwitchChange,
      timeDelivery,
      off,
    );

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Información de contacto guardada');

        (store.user.first || store.service == 0)
            ? Navigator.push(
                context, locationStoreRoute(prefs.addressSearchSave))
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
