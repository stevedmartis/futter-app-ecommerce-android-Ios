import 'dart:ui';

import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_cart.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

showMaterialCupertinoBottomSheet(
    BuildContext context, String titulo, String subtitulo) {
  if (UniversalPlatform.isIOS) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: GroceryStoreCart(
            cartHome: true,
          )),
    );
  } else if (UniversalPlatform.isAndroid) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Action One'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Action Two'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

showSelectServiceMaterialCupertinoBottomSheet(context) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

  final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

  return showModalBottomSheet(
    // enableDrag: false,
    //isDismissible: false,
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: (currentTheme.customTheme)
            ? currentTheme.currentTheme.cardColor
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*  Container(
                margin: EdgeInsets.only(top: 20, left: 125, right: 125),
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54.withOpacity(0.20),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ), */
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Tipo de tienda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Selecciona una categoria",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 10.0,
                child: Center(
                  child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: (currentTheme.customTheme)
                          ? Colors.white54.withOpacity(0.20)
                          : Colors.black54.withOpacity(0.20)),
                ),
              ),
              Material(
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () => {
                    authService.serviceChange = 1,
                    Navigator.of(context).pop(),
                    /*     showSnackBar(
                        context, 'Tu tienda aparecera en "Restaurantes" '), */
                  },
                  child: ListTile(
                      tileColor: (currentTheme.customTheme)
                          ? currentTheme.currentTheme.cardColor
                          : Colors.white,
                      leading: Icon(Icons.restaurant_menu,
                          size: 25,
                          color: currentTheme.currentTheme.accentColor),
                      title: Text(
                        'Restaurante',
                        style: TextStyle(
                            fontSize: 15,
                            color: (currentTheme.customTheme)
                                ? Colors.white54
                                : Colors.black54),
                      ),
                      trailing: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: (authService.serviceSelect == 1) ? 1.0 : 0.0,
                        child: Container(
                          child: Icon(Icons.check_circle,
                              color: currentTheme.currentTheme.primaryColor,
                              size: 30.0),
                        ),
                      )

                      //trailing:
                      ),
                ),
              ),
              SizedBox(
                height: 10.0,
                child: Center(
                  child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: (currentTheme.customTheme)
                          ? Colors.white54.withOpacity(0.20)
                          : Colors.black54.withOpacity(0.20)),
                ),
              ),
              Material(
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () => {
                    authService.serviceChange = 2,
                    Navigator.of(context).pop(),
                    //showSnackBar(context, 'Tu tienda aparecera en "Mercados" '),
                  },
                  child: ListTile(
                      tileColor: (currentTheme.customTheme)
                          ? currentTheme.currentTheme.cardColor
                          : Colors.white,
                      leading: FaIcon(FontAwesomeIcons.lemon,
                          size: 25,
                          color: currentTheme.currentTheme.accentColor),
                      title: Text(
                        'Fruteria/Verduleria',
                        style: TextStyle(
                            fontSize: 15,
                            color: (currentTheme.customTheme)
                                ? Colors.white54
                                : Colors.black54),
                      ),
                      trailing: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: (authService.serviceSelect == 2) ? 1.0 : 0.0,
                        child: Container(
                          child: Icon(
                            Icons.check_circle,
                            color: currentTheme.currentTheme.primaryColor,
                            size: 30.0,
                          ),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 10.0,
                child: Center(
                  child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: (currentTheme.customTheme)
                          ? Colors.white54.withOpacity(0.20)
                          : Colors.black54.withOpacity(0.20)),
                ),
              ),
              Material(
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () => {
                    authService.serviceChange = 3,
                    Navigator.of(context).pop(),
                    /*  showSnackBar(
                        context, 'Tu tienda aparecera en "Licorerias" '), */
                  },
                  child: ListTile(
                      tileColor: (currentTheme.customTheme)
                          ? currentTheme.currentTheme.cardColor
                          : Colors.white,
                      leading: FaIcon(FontAwesomeIcons.wineBottle,
                          size: 25,
                          color: currentTheme.currentTheme.accentColor),
                      title: Text(
                        'Licoreria/Botilleria',
                        style: TextStyle(
                            fontSize: 15,
                            color: (currentTheme.customTheme)
                                ? Colors.white54
                                : Colors.black54),
                      ),
                      trailing: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: (authService.serviceSelect == 3) ? 1.0 : 0.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: currentTheme.currentTheme.primaryColor,
                          ),
                          iconSize: 30.0,
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          },
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 10.0,
                child: Center(
                  child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: (currentTheme.customTheme)
                          ? Colors.white54.withOpacity(0.20)
                          : Colors.black54.withOpacity(0.20)),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

showMaterialCupertinoBottomSheetLocation(BuildContext context, String titulo,
    String subtitulo, VoidCallback onPress, VoidCallback onCancel) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);
  final size = MediaQuery.of(context).size;

  if (UniversalPlatform.isIOS) {
    return showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => ClipRRect(
                child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 9.0,
                sigmaY: 9.0,
              ),
              child: Container(
                  height: size.height / 1.0,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: TextField(
                          style: TextStyle(
                            color: (currentTheme.currentTheme.accentColor),
                          ),
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
                                  color: currentTheme.currentTheme.accentColor,
                                  width: 2.0),
                            ),
                            hintText: '',
                            labelText: 'Calle y número',

                            //counterText: snapshot.data,
                          ),
                          onChanged: (value) =>
                              myLocationBloc.searchPlaces(value),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<List<PlaceSearch>>(
                        stream: myLocationBloc.searchResults.stream,
                        builder: (context,
                            AsyncSnapshot<List<PlaceSearch>> snapshot) {
                          if (snapshot.hasData) {
                            final places = snapshot.data;

                            if (places.length > 0)
                              return Column(
                                children: [
                                  Container(
                                    child: ListView.builder(
                                        itemCount: places.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final place = places[index];
                                          return ListTile(
                                            onTap: () => {
                                              Navigator.push(context,
                                                  confirmLocationRoute(place)),
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode()),
                                            },
                                            title: Text(
                                              place.structuredFormatting
                                                  .mainText,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  place.structuredFormatting
                                                      .secondaryText,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  Container(
                                    child: Divider(
                                      height: 50,
                                    ),
                                  ),
                                ],
                              );

                            return Container();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Container();
                          }
                        },
                      ),

                      /* Expanded(
                          flex: 1,
                          child: elevatedButtonCustom(
                              context: context,
                              title: 'Continuar',
                              onPress: () {})), */
                      GestureDetector(
                        onTap: () => onPress(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.room_outlined,
                              size: 25,
                              color: currentTheme.currentTheme.accentColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Container(
                                child: Text(
                                  'Ubicación actual',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )));
  } else if (UniversalPlatform.isAndroid) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Action One'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Action Two'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
