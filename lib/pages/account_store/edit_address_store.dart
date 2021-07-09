import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/responses/place_search_response.dart';

import 'package:australti_ecommerce_app/routes/routes.dart';

import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LocationStorePage extends StatefulWidget {
  LocationStorePage(this.place);
  final PlacesSearch place;
  @override
  _LocationStorePageState createState() => _LocationStorePageState();
}

class _LocationStorePageState extends State<LocationStorePage> {
  final _blocLocation = MyLocationBloc();
  bool loading = false;
  Store store;
  final locationBloc = LocationBloc();

  final addressSelectCtrl = TextEditingController();
  final citySelectCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    addressSelectCtrl.text = widget.place.mainText;
    citySelectCtrl.text = widget.place.secondaryText;
    numberCtrl.text = (widget.place.number == '0') ? '' : widget.place.number;
    super.initState();
  }

  /*  @override
  void dispose() {
    myLocationBloc.dispose();
    super.dispose();
    // roomBloc.disposeRooms();
  }
 */
  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  final FocusScopeNode _node = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    // final roomsModel = Provider.of<Room>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
                appBar: AppBar(
                  title: _showTitle ? Text('Editar dirección') : Text(''),
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
                        ? StreamBuilder<String>(
                            stream: _blocLocation.numberAddress.stream,
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              final places = snapshot.data;

                              bool isDisabled = false;
                              (places != null)
                                  ? (places != "")
                                      ? isDisabled = true
                                      : isDisabled = false
                                  : isDisabled = false;

                              return IconButton(
                                color: (!isDisabled)
                                    ? Colors.grey
                                    : currentTheme.accentColor,
                                icon: Icon(
                                  Icons.check,
                                  size: 35,
                                ),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  if (isDisabled) {
                                    _editAddress();
                                  }
                                },
                              );
                            },
                          )
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
                                    'Editar dirección',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // email

                                StreamBuilder(
                                  stream: locationBloc.addressStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return Expanded(
                                      flex: -1,
                                      child: Container(
                                        child: TextField(
                                          onEditingComplete: _node.nextFocus,
                                          controller: addressSelectCtrl,
                                          style: TextStyle(
                                            color: (currentTheme.accentColor),
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white54,
                                                ),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Colors.white54,
                                              ),
                                              // icon: Icon(Icons.perm_identity),
                                              //  fillColor: currentTheme.accentColor,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: currentTheme
                                                        .accentColor,
                                                    width: 2.0),
                                              ),
                                              hintText: '',
                                              labelText: 'Calle y Número',
                                              errorText: snapshot.error),
                                          onChanged: locationBloc.changeAddress,

                                          //counterText: snapshot.data,

                                          /*  onChanged: (value) =>
                                      myLocationBloc.searchPlaces(value), */
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  flex: -1,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextField(
                                      enabled: false,
                                      onEditingComplete: _node.nextFocus,
                                      controller: citySelectCtrl,
                                      style: TextStyle(
                                        color: (currentTheme.accentColor),
                                      ),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white54,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                        labelText: 'Ciudad',

                                        //counterText: snapshot.data,
                                      ),
                                      /*  onChanged: (value) =>
                                      myLocationBloc.searchPlaces(value), */
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: -1,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: TextField(
                                        onEditingComplete: _node.nextFocus,
                                        controller: numberCtrl,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color: (currentTheme.accentColor),
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white54,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
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
                                          labelText: 'Piso/Apartamento',

                                          //counterText: snapshot.data,
                                        ),
                                        onChanged: (value) => _blocLocation
                                            .changeNumberAddress(value)),
                                  ),
                                ),
                              ]),
                            )
                          ]))
                    ]))));
  }

  _editAddress() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeProfile = authService.storeAuth;

    final address = addressSelectCtrl.text.trim();
    final number = numberCtrl.text.trim();

    setState(() {
      loading = true;
    });

    final editProfileOk = await authService.editAddressStoreProfile(
        storeProfile.user.uid, address, number);

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Categoria guardada');

        (storeProfile.user.first || storeProfile.service == 0)
            ? Navigator.push(context, profileEditRoute())
            : Navigator.pop(context);
      } else {
        showAlertError(context, 'Error', 'Intente más tarde.');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }
}
