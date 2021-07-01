import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/pages/add_edit_category.dart';
import 'package:australti_ecommerce_app/responses/stores_list_principal_response.dart';
import 'package:australti_ecommerce_app/services/stores_Services.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ConfirmLocationPage extends StatefulWidget {
  ConfirmLocationPage(this.place);
  final PlaceSearch place;
  @override
  _ConfirmLocationPagetate createState() => _ConfirmLocationPagetate();
}

class _ConfirmLocationPagetate extends State<ConfirmLocationPage> {
  final _bloc = TabsViewScrollBLoC();

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
              )),
          backgroundColor: Colors.black,
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
                    Expanded(
                      flex: 2,
                      child: Container(
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
                    ),

                    // email

                    StreamBuilder(
                      stream: locationBloc.addressStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                    borderSide: BorderSide(
                                        color: currentTheme.accentColor,
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
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            // icon: Icon(Icons.perm_identity),
                            //  fillColor: currentTheme.accentColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: currentTheme.accentColor, width: 2.0),
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
                                borderSide: BorderSide(color: Colors.white),
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
                            onChanged: (value) =>
                                _blocLocation.changeNumberAddress(value)),
                      ),
                    ),
                    Spacer(),
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

                        return Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
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

                                storesByLocationlistServices(
                                    citySelectCtrl.text);

                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              child: Center(
                                child: confirmButton(
                                    'Confirmar',
                                    [
                                      currentTheme.primaryColor,
                                      Color(0xff3AFF3E),
                                      Color(0xff42FF00),
                                      currentTheme.primaryColor,
                                    ],
                                    false,
                                    isDisabled),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // password

                    // submit
                  ],
                )),
          )),
    ));

    /* CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Confirma tu dirección'),
                
                //makeListProducts(context)
              ]), */
  }

  void storesByLocationlistServices(String location) async {
    final storeService = Provider.of<StoreService>(context, listen: false);

    final StoresListResponse resp =
        await storeService.getStoresLocationListServices(location);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.storesListInitial = [];
      storeBloc.storesListInitial = resp.storeListServices;

      storeBloc.changeToMarket();
    }
  }

  SliverList makeListCatalogos(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      CatalogsList(
        bloc: _bloc,
        place: widget.place,
      ),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                        showTitle: _showTitle,
                        title: title,
                        leading: true,
                        isAdd: false,
                        action: Container(),
                        //   Container()
                        onPress: () => {})))));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
}

class CatalogsList extends StatefulWidget {
  CatalogsList({this.bloc, this.place});

  final TabsViewScrollBLoC bloc;

  final PlaceSearch place;

  @override
  _CatalogsListState createState() => _CatalogsListState();
}

class _CatalogsListState extends State<CatalogsList>
    with TickerProviderStateMixin {
  Profile profile;

  SlidableController slidableController;
  final addressSelectCtrl = TextEditingController();
  final citySelectCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.bloc.init(this, context);

    addressSelectCtrl.text = widget.place.structuredFormatting.mainText;
    citySelectCtrl.text = widget.place.structuredFormatting.secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormAddressWidget();
  }

  Widget _buildFormAddressWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Confirma tu dirección',
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: currentTheme.currentTheme.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: -10,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: TextField(
                        controller: addressSelectCtrl,
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
                          labelText: 'Dirección',

                          //counterText: snapshot.data,
                        ),
                        /*  onChanged: (value) =>
                                    myLocationBloc.searchPlaces(value), */
                      ),
                    ),
                  ),
                  Expanded(
                    flex: -10,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: TextField(
                        controller: citySelectCtrl,
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
                          labelText: 'Ciudad',

                          //counterText: snapshot.data,
                        ),
                        /*  onChanged: (value) =>
                                    myLocationBloc.searchPlaces(value), */
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: TextField(
                        controller: numberCtrl,
                        keyboardType: TextInputType.number,
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
                          labelText: 'Numero Departamento/Casa/Oficina',

                          //counterText: snapshot.data,
                        ),
                        /*  onChanged: (value) =>
                                    myLocationBloc.searchPlaces(value), */
                      ),
                    ),
                  ),
                  Container(
                      child: elevatedButtonCustom(
                          context: context,
                          title: 'Continuar',
                          onPress: () {})),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route createRouteAddEditCategory(
    ProfileStoreCategory category, bool isEdit, TabsViewScrollBLoC bloc) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateCategoryPage(category: category, isEdit: isEdit, bloc: bloc),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}
