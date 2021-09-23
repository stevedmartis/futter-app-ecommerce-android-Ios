import 'dart:ui';

import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/bloc/store_profile.dart';
import 'package:freeily/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:freeily/grocery_store/grocery_store_cart.dart';
import 'package:freeily/models/bank_account.dart';

import 'package:freeily/models/place_Search.dart';
import 'package:freeily/models/store.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/profile_store.dart/profile_store_user.dart';
import 'package:freeily/routes/routes.dart';

import 'package:freeily/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

showMaterialCupertinoBottomSheet(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => Container(
        height: size.height / 1.2,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: GroceryStoreCart(
          cartHome: true,
        )),
  );
}

showStoreSelectMaterialCupertinoBottomSheet(
    BuildContext context, bool isAuth, Store store) {
  if (UniversalPlatform.isIOS) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: 900,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: ProfileStoreSelect(
            store: store,
            isAuthUser: isAuth,
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

showLocationMaterialCupertinoBottomSheet(BuildContext context,
    VoidCallback onPress, VoidCallback onCancel, Widget radio) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);
  final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);
  final prefs = AuthUserPreferences();
  final size = MediaQuery.of(context).size;

  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 9.0,
          sigmaY: 9.0,
        ),
        child: Container(
            color: Colors.black,
            height: size.height / 1.16,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Cambiar dirección",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    style: TextStyle(
                      color: (Colors.white),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      showMaterialCupertinoBottomSheetLocation(
                          context, onPress, onCancel, true);
                    },
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
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: currentTheme.currentTheme.primaryColor,
                      ),
                      //  fillColor: currentTheme.primaryColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: currentTheme.currentTheme.primaryColor,
                            width: 2.0),
                      ),
                      hintText: '',
                      labelText: 'Ingrese dirección',

                      //counterText: snapshot.data,
                    ),
                  ),
                ),
                ListTile(
                    onTap: () {
                      final place = prefs.addressSearchSave;

                      var placeSave = new PlaceSearch(
                          description: authBloc.storeAuth.user.uid,
                          placeId: authBloc.storeAuth.user.uid,
                          structuredFormatting: new StructuredFormatting(
                              mainText: place.mainText,
                              secondaryText: place.secondaryText,
                              number: place.number));

                      Navigator.push(context, confirmLocationRoute(placeSave));
                    },
                    leading: Icon(Icons.home,
                        size: 25,
                        color: currentTheme.currentTheme.primaryColor),
                    title: Text(
                      prefs.addressSearchSave != ''
                          ? '${prefs.addressSearchSave.mainText}'
                          : '...',
                      style: TextStyle(
                          fontSize: 15,
                          color: (currentTheme.customTheme)
                              ? Colors.white54
                              : Colors.black54),
                    ),
                    trailing: radio
                    //trailing:
                    ),
              ],
            )),
      ),
    ),
  );
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
                          color: currentTheme.currentTheme.primaryColor),
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
                          color: currentTheme.currentTheme.primaryColor),
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
                          color: currentTheme.currentTheme.primaryColor),
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

showMaterialCupertinoBottomSheetLocation(BuildContext context,
    VoidCallback onPress, VoidCallback onCancel, bool isChange) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

  return showModalBottomSheet(
      enableDrag: isChange,
      isDismissible: isChange,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox.expand(
            child: DraggableScrollableSheet(
                initialChildSize: isChange ? 0.78 : 0.97,
                minChildSize: 0.2,
                maxChildSize: 0.97,
                builder: (_, controller) {
                  return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 9.0,
                          sigmaY: 9.0,
                        ),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: TextField(
                                    autofocus: true,
                                    style: TextStyle(
                                      color: (Colors.white),
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
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle: TextStyle(
                                        color: (currentTheme.customTheme)
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                      prefixIcon: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white),
                                      //  fillColor: currentTheme.primaryColor,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: currentTheme
                                                .currentTheme.primaryColor,
                                            width: 2.0),
                                      ),
                                      hintText: '',
                                      labelText: 'Ingrese Calle y número',

                                      //counterText: snapshot.data,
                                    ),
                                    onChanged: (value) =>
                                        myLocationBloc.searchPlaces(value),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  flex: -4,
                                  child: StreamBuilder<List<PlaceSearch>>(
                                    stream: myLocationBloc.searchResults.stream,
                                    builder: (context,
                                        AsyncSnapshot<List<PlaceSearch>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        final places = snapshot.data;

                                        if (places.length > 0)
                                          return Container(
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: places.length,
                                                shrinkWrap: true,
                                                controller: controller,
                                                itemBuilder: (context, index) {
                                                  final place = places[index];
                                                  return ListTile(
                                                    onTap: () => {
                                                      HapticFeedback
                                                          .lightImpact(),
                                                      Navigator.push(
                                                          context,
                                                          confirmLocationRoute(
                                                              place)),
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
                                                          place
                                                              .structuredFormatting
                                                              .secondaryText,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          );

                                        return Container();
                                      } else if (snapshot.hasError) {
                                        return Container();
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    onPress();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                ),

                                /* Expanded(
                      flex: 1,
                      child: elevatedButtonCustom(
                          context: context,
                          title: 'Continuar',
                          onPress: () {})), */
                              ],
                            )),
                      ));
                }),
          ));
}

showMaterialCupertinoBottomSheetBanks(
  BuildContext context,
  VoidCallback onPress,
  VoidCallback onCancel,
) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.75,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: currentTheme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 125, right: 125),
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Bank>>(
                        stream: storeProfileBloc.banksResults.stream,
                        builder: (context, AsyncSnapshot<List<Bank>> snapshot) {
                          if (snapshot.hasData) {
                            final banks = snapshot.data;
                            if (banks != null) if (banks.length > 0)
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: ListView.builder(
                                    controller: controller,
                                    scrollDirection: Axis.vertical,
                                    itemCount: banks.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final bank = banks[index];
                                      return Material(
                                        color: currentTheme.cardColor,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          child: ListTile(
                                            onTap: () => {
                                              HapticFeedback.lightImpact(),
                                              storeProfileBloc.setBankSelected =
                                                  bank,
                                              Navigator.pop(context),
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode()),
                                            },
                                            leading: (bank.image != '')
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: Image.asset(
                                                          bank.image,
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                        )),
                                                  )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                            title: Container(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                bank.nameBank,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );

                            return Container();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
}

showContactOptionsStoreMCBottomSheet(context, Store store) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

  final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

  final instagramStore = store.instagram.toString();

  final emailStore = store.user.email.toString();

  _launchInstagramProfile(String instagram) async {
    var url = 'https://www.instagram.com/$instagram/?hl=es';

    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  _launchMessageEmail(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=Hola&body=Mensage');

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                  "Contacto",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Divider(),
              if (instagramStore != "")
                Material(
                  color: currentTheme.currentTheme.scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchInstagramProfile(store.instagram);
                    },
                    child: ListTile(
                        tileColor: (currentTheme.customTheme)
                            ? currentTheme.currentTheme.cardColor
                            : Colors.white,
                        leading: FaIcon(FontAwesomeIcons.instagram,
                            size: 25, color: Colors.white),
                        title: Text(
                          'Instagram',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '@${store.instagram}',
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
              Divider(),
              if (emailStore != "")
                Material(
                  color: currentTheme.currentTheme.scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchMessageEmail(store.user.email);
                    },
                    child: ListTile(
                        tileColor: (currentTheme.customTheme)
                            ? currentTheme.currentTheme.cardColor
                            : Colors.white,
                        leading: Icon(Icons.email_outlined,
                            size: 25, color: Colors.white),
                        title: Text(
                          'Correo electrónico',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        subtitle: Text(
                          '$emailStore',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        trailing: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: (authService.serviceSelect == 3) ? 1.0 : 0.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            iconSize: 30.0,
                            onPressed: () => {
                              Navigator.of(context).pop(),
                            },
                          ),
                        )),
                  ),
                ),
              if (emailStore != "") Divider(),
            ],
          ),
        ),
      ),
    ),
  );
}
