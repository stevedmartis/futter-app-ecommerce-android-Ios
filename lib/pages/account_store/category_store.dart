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

class CategorySelectStore extends StatefulWidget {
  @override
  _CategorySelectStoreState createState() => _CategorySelectStoreState();
}

class _CategorySelectStoreState extends State<CategorySelectStore> {
  final storeProfileBloc = StoreProfileBloc();

  final categoryCtrl = TextEditingController();
  bool loading = false;
  Store store;
  @override
  void initState() {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (store.user.first) openSheetBottom();

      authService.serviceChange = store.service;
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

    if (authService.serviceSelect == 2) categoryCtrl.text = 'Restaurante';

    if (authService.serviceSelect == 1)
      categoryCtrl.text = 'Frutería/Verdulería';
    if (authService.serviceSelect == 3)
      categoryCtrl.text = 'Licorería/Botillería';

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              leading: IconButton(
                  color: currentTheme.primaryColor,
                  icon: Icon(
                    Icons.chevron_left,
                    size: 40,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (authService.isChangeToSale) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  }),
              actions: [
                (!loading)
                    ? IconButton(
                        color: (authService.serviceSelect != store.service)
                            ? currentTheme.primaryColor
                            : Colors.grey,
                        icon: Icon(
                          Icons.check,
                          size: 35,
                        ),
                        onPressed: () {
                          if (authService.serviceSelect != store.service)
                            _editProfile();
                        })
                    : buildLoadingWidget(context),
              ],
            ),
            backgroundColor: currentTheme.scaffoldBackgroundColor,
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
                      Container(
                        width: size.width,
                        child: Text(
                          '¿En qué categoria te calificarías?',
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
                          'Las categorias ayudan a las personas a encontrarte.',
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // email

                      _createCategory(),

                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsetsDirectional.only(
                                          start: 0.0, end: 0.0),
                                      height: 1.0,
                                      color: Colors.black54.withOpacity(0.20)),
                                ),
                              ),
                              Material(
                                color: currentTheme.scaffoldBackgroundColor,
                                child: InkWell(
                                  onTap: () => {
                                    authService.serviceChange = 2,
                                  },
                                  child: ListTile(
                                      tileColor:
                                          currentTheme.scaffoldBackgroundColor,
                                      title: Text(
                                        'Restaurante',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: (authService.serviceSelect == 2)
                                          ? Container(
                                              child: Icon(Icons.check_circle,
                                                  color:
                                                      currentTheme.primaryColor,
                                                  size: 30.0),
                                            )
                                          : Container(
                                              child: Icon(Icons.circle_outlined,
                                                  color: Colors.grey,
                                                  size: 30.0),
                                            )

                                      //trailing:
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsetsDirectional.only(
                                          start: 0.0, end: 0.0),
                                      height: 1.0,
                                      color: Colors.black54.withOpacity(0.20)),
                                ),
                              ),
                              Material(
                                color: currentTheme.scaffoldBackgroundColor,
                                child: InkWell(
                                  onTap: () => {
                                    authService.serviceChange = 1,
                                  },
                                  child: ListTile(
                                      tileColor:
                                          currentTheme.scaffoldBackgroundColor,
                                      title: Text(
                                        'Fruteria/Verduleria',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: (authService.serviceSelect == 1)
                                          ? Container(
                                              child: Icon(Icons.check_circle,
                                                  color:
                                                      currentTheme.primaryColor,
                                                  size: 30.0),
                                            )
                                          : Container(
                                              child: Icon(Icons.circle_outlined,
                                                  color: Colors.grey,
                                                  size: 30.0),
                                            )),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsetsDirectional.only(
                                          start: 0.0, end: 0.0),
                                      height: 1.0,
                                      color: Colors.black54.withOpacity(0.20)),
                                ),
                              ),
                              Material(
                                color: currentTheme.scaffoldBackgroundColor,
                                child: InkWell(
                                  onTap: () => {
                                    authService.serviceChange = 3,
                                  },
                                  child: ListTile(
                                      tileColor:
                                          currentTheme.scaffoldBackgroundColor,
                                      title: Text(
                                        'Licoreria/Botilleria',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: (authService.serviceSelect == 3)
                                          ? Container(
                                              child: Icon(Icons.check_circle,
                                                  color:
                                                      currentTheme.primaryColor,
                                                  size: 30.0),
                                            )
                                          : Container(
                                              child: Icon(Icons.circle_outlined,
                                                  color: Colors.grey,
                                                  size: 30.0),
                                            )),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsetsDirectional.only(
                                          start: 0.0, end: 0.0),
                                      height: 1.0,
                                      color: Colors.black54.withOpacity(0.20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // password

                      // submit
                    ],
                  )),
            )));
  }

  Widget _createCategory() {
    return StreamBuilder(
      stream: storeProfileBloc.categoryStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            enabled: false,
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: categoryCtrl,
            showCursor: true,
            readOnly: true,
            onTap: () {},
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
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
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Categoría',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeCategory,
          ),
        );
      },
    );
  }

  _editProfile() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeProfile = store;

    setState(() {
      loading = true;
    });

    final editProfileOk = await authService.editServiceStoreProfile(
        storeProfile.user.uid, authService.serviceSelect);

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Categoria guardada');

        (authService.isChangeToSale)
            ? Navigator.push(context, contactoInfoStoreRoute())
            : Navigator.pop(context);
      } else {
        showAlertError(context, 'Error', '');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }
}
