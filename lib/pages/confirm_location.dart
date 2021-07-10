import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/responses/stores_list_principal_response.dart';
import 'package:australti_ecommerce_app/services/stores_Services.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';

import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfirmLocationPage extends StatefulWidget {
  ConfirmLocationPage(this.place);
  final PlaceSearch place;
  @override
  _ConfirmLocationPagetate createState() => _ConfirmLocationPagetate();
}

class _ConfirmLocationPagetate extends State<ConfirmLocationPage> {
  final _blocLocation = MyLocationBloc();

  final locationBloc = LocationBloc();

  final addressSelectCtrl = TextEditingController();
  final citySelectCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    addressSelectCtrl.text = widget.place.structuredFormatting.mainText;
    citySelectCtrl.text = widget.place.structuredFormatting.secondaryText;

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

    final authBloc = Provider.of<AuthenticationBLoC>(context);

    return SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
                appBar: AppBar(
                  title: _showTitle ? Text('Confirmar dirección') : Text(''),
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
                    StreamBuilder<String>(
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
                            HapticFeedback.mediumImpact();
                            if (isDisabled) {
                              var placeSearch = new PlaceSearch(
                                  description: addressSelectCtrl.text,
                                  placeId: widget.place.placeId,
                                  structuredFormatting:
                                      new StructuredFormatting(
                                          mainText: addressSelectCtrl.text,
                                          secondaryText: citySelectCtrl.text,
                                          number: places));

                              myLocationBloc
                                  .savePlaceSearchConfirm(placeSearch);

                              storesByLocationlistServices(citySelectCtrl.text,
                                  authBloc.storeAuth.user.uid);

                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                backgroundColor: Colors.black,
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
                                    'Confirmar dirección',
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

  void storesByLocationlistServices(String location, String uid) async {
    final storeService = Provider.of<StoreService>(context, listen: false);

    final StoresListResponse resp =
        await storeService.getStoresLocationListServices(location, uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.storesListInitial = [];
      storeBloc.storesListInitial = resp.storeListServices;

      storeBloc.changeToMarket();
    }
  }
}
