import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/single_image_upload.dart';
import 'package:australti_ecommerce_app/responses/product_response.dart';
import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/services/product.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

import "package:universal_html/html.dart" as html;
import 'package:universal_platform/universal_platform.dart';

class AddUpdateProductPage extends StatefulWidget {
  AddUpdateProductPage({this.product, @required this.isEdit, this.category});

  final ProfileStoreProduct product;
  final bool isEdit;
  final String category;

  @override
  _AddUpdateProductPageState createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage>
    with TickerProviderStateMixin {
  final nameCtrl = TextEditingController();

  final productBloc = ProductBloc();

  final descriptionCtrl = TextEditingController();

  final priceCtrl = TextEditingController();
  final catalogoService = new StoreCategoiesService();

  Store storeAuth;
  // final potCtrl = TextEditingController();

  bool isNameChange = false;
  bool isAboutChange = false;

  bool isSwitchedVisibility = true;

  bool isVisibilityChange = false;

  bool errorRequired = false;
  bool isControllerChangeEdit = false;
  bool loading = false;

  String optionItemSelected = "1";

  bool isDefault;

  FocusNode _focusNode;
  bool optionSelectChange = false;

  FixedExtentScrollController firstController;

  bool isWeb = UniversalPlatform.isWeb;

  int index = 0;

  List<Object> images = [];

  final picker = ImagePicker();

  int selectedValue;
  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.product.name;
    descriptionCtrl.text = widget.product.description;
    priceCtrl.text = widget.product.price.toString();
    setState(() {
      if (widget.isEdit) images.addAll(widget.product.images);
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });

    //  plantBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.product.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;

        if (nameCtrl.text == "" || nameCtrl.text.length < 5)
          errorRequired = true;
        else
          errorRequired = false;
      });
    });
    descriptionCtrl.addListener(() {
      setState(() {
        if (widget.product.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;

        if (descriptionCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();

    descriptionCtrl.dispose();
    productBloc.dispose();
    images.clear();
    images = [];
    tabsViewScrollBLoC.disposeImages();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

//    final size = MediaQuery.of(context).size;

    final isControllerChange = isNameChange;

    final isControllerChangeEdit =
        isNameChange || isAboutChange || isVisibilityChange;

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            (currentTheme.customTheme) ? Colors.black : Colors.white,
        actions: [
          (!loading)
              ? (widget.isEdit)
                  ? _createButton(isControllerChangeEdit)
                  : _createButton(isControllerChange)
              : buildLoadingWidget(context),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.currentTheme.accentColor,
          ),
          iconSize: 30,
          onPressed: () =>
              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context),
          color: Colors.white,
        ),
        centerTitle: true,
        title: (widget.isEdit)
            ? Text(
                'Editar producto',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              )
            : Text(
                'Crear producto',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              ),
      ),
      body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          // controller: _scrollController,
          slivers: <Widget>[
            SliverFixedExtentList(
              itemExtent: 150,
              delegate: SliverChildListDelegate(
                [
                  FadeIn(
                    child: Container(
                        child: (UniversalPlatform.isWeb)
                            ? Center(
                                child: Container(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: (uploadedImages.length > 0)
                                            ? ListView.builder(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    uploadedImages.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final stripped = uploadedImages[
                                                          index]
                                                      .replaceFirst(
                                                          RegExp(
                                                              r'data:image/[^;]+;base64,'),
                                                          '');

                                                  final itemData =
                                                      base64.decode(stripped);

                                                  return Container(
                                                    width: 150,
                                                    height: 150,
                                                    child: Card(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Image.memory(
                                                          itemData),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                width: 150,
                                                height: 150,
                                                child: Card(
                                                  child: IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      _getImagesWeb();
                                                    },
                                                  ),
                                                ),
                                              ))),
                              )
                            : SingleImageUpload(
                                images: images,
                                isEdit: widget.isEdit,
                              )),
                  )
                ],
              ),
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      _createName(),
                      SizedBox(
                        height: 20,
                      ),
                      _createDescription(),
                      SizedBox(
                        height: 20,
                      ),
                      _createPrice(),

                      //  _createVisibility()
                      //_createPrivacity(),
                      /*  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            ButtonWidget(
                              onClicked: () => Utils.showSheet(
                                context,
                                child: buildCustomPicker(),
                                onClicked: () {
                                  final value = values[index];
                                  Utils.showSnackBar(
                                      context, 'Selected "$value"');

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ), */
                    ],
                  ),
                )),
          ]),
    );
  }

  List<String> uploadedImages = [];
  List<html.File> files = [];
  List<int> imageFileBytes;
  List<int> _selectedFile;
  Uint8List _bytesData;

  Future<void> _getImagesWeb() async {
    final completer = Completer<List<String>>();
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..multiple = true
      ..accept = 'image/*';
    input.click();
    // onChange doesn't work on mobile safari
    input.addEventListener('change', (e) async {
      files = input.files;
      Iterable<Future<String>> resultsFutures = files.map((file) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((event) async {
          _handleResult(reader.result, file);

          var _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          setState(() {
            imageFileBytes = _bytesData;
          });
        });
        reader.onError.listen((error) => completer.completeError(error));
        return reader.onLoad.first.then((_) => reader.result as String);
      });
      final results = await Future.wait(resultsFutures);
      completer.complete(results);
    });
    // need to append on mobile safari
    html.document.body.append(input);
    // input.click(); can be here
    final List<String> images = await completer.future;

    setState(() {
      uploadedImages = images;
    });
    input.remove();
  }

  Future _handleResult(Object result, html.File file) async {
    final productService =
        Provider.of<StoreProductService>(context, listen: false);

    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });

    final filemMultiPart =
        await productService.multiPartFileImageWeb(_selectedFile, file);

    tabsViewScrollBLoC.addImageProduct(filemMultiPart);
  }

  Widget _createName() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: productBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            focusNode: _focusNode,
            controller: nameCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
            ],
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
                labelText: 'Nombre *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: productBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: productBloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(100),
            ],
            controller: descriptionCtrl,
            //  keyboardType: TextInputType.emailAddress,

            maxLines: 2,
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
                labelText: 'Descripción *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: productBloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createPrice() {
    return StreamBuilder(
      stream: productBloc.priceSteam,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: priceCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      new String.fromCharCodes(new Runes('\u0024')),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    )),
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
                labelText: 'Precio',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: productBloc.changePrice,
          ),
        );
      },
    );
  }

/* 
  TextEditingController _controller = TextEditingController();
  Future<void> _selectedNumber(BuildContext context) async {
    int number = await showPicker();
  }
 */
/*   Widget _createPrivacity() {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    List<DropdownMenuItem> categories = [
      DropdownMenuItem(
        child: Text(
          'Todos',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "1",
      ),
      DropdownMenuItem(
        child: Text(
          'Mis suscriptores',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "2",
      ),
      DropdownMenuItem(
        child: Text(
          'Nadie',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "3",
      )
    ];

    return StreamBuilder(
      stream: productBloc.privacityStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(

            //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
            height: 50,
            width: size.width,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: (currentTheme.customTheme)
                              ? Colors.white54
                              : Colors.black54))),
              dropdownColor:
                  (currentTheme.customTheme) ? Colors.black : Colors.white,
              hint: Text(
                'Mostrar con: ',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
              ),
              value: optionItemSelected,
              items: categories,
              onChanged: (optionItem) {
                setState(() {
                  optionItemSelected = optionItem;
                  optionSelectChange = true;
                });
              },
            ));
      },
    );
  }
 */
  Widget _createButton(
    bool isControllerChange,
  ) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final productService = Provider.of<StoreProductService>(context);

    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              (widget.isEdit) ? 'Guardar' : 'Crear',
              style: TextStyle(
                  color: (isControllerChange && !errorRequired ||
                          productService.isImagesChange)
                      ? currentTheme.accentColor
                      : Colors.grey,
                  fontSize: 18),
            ),
          ),
        ),
        onTap: isControllerChange && !errorRequired && !loading ||
                productService.isImagesChange
            ? () => {
                  setState(() {
                    loading = true;
                  }),
                  FocusScope.of(context).unfocus(),
                  (widget.isEdit) ? _editProduct() : _createProduct(),
                }
            : null);
  }

  _createProduct() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final store = authService.storeAuth;
    final productService =
        Provider.of<StoreProductService>(context, listen: false);

    final name = (productBloc.name == null)
        ? widget.product.name
        : productBloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.product.description
        : productBloc.description.trim();

    final price = priceCtrl.text;

    final imagesProduct = await productService.uploadImagesProducts(
        tabsViewScrollBLoC.imagesProducts, storeAuth.user.uid);

    if (imagesProduct != null) {
      final newProduct = ProfileStoreProduct(
          id: '2-c',
          name: name,
          price: int.parse(price),
          description: description,
          images: imagesProduct.images,
          category: widget.category,
          user: store.user.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

      final ProductResponse resp =
          await productService.createProduct(newProduct);

      if (resp.ok) {
        final productProvider =
            Provider.of<TabsViewScrollBLoC>(context, listen: false);

        productProvider.addProductsByCategory(this, resp.product, context);

        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Producto creado con exito!');

        Navigator.pop(context);
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
  }

  _editProduct() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final store = authService.storeAuth;
    final productService =
        Provider.of<StoreProductService>(context, listen: false);

    final name = nameCtrl.text;
    final description = descriptionCtrl.text;

    final price = priceCtrl.text;

    List<ImageProduct> imagesFinal = [];

    final item =
        images.firstWhere((item) => item is ImageProduct, orElse: () => null);

    if (item != null) {
      imagesFinal.add(item);
    }

    if (tabsViewScrollBLoC.imagesProducts.length != 0) {
      final imagesProduct = await productService.uploadImagesProducts(
          tabsViewScrollBLoC.imagesProducts, storeAuth.user.uid);

      if (imagesProduct != null) {
        for (var item in imagesProduct.images) {
          imagesFinal.add(item);
        }

        final productEdit = ProfileStoreProduct(
            id: widget.product.id,
            name: name,
            price: int.parse(price),
            description: description,
            images: imagesFinal,
            category: widget.product.category,
            user: store.user.uid,
            createdAt: widget.product.createdAt,
            updatedAt: widget.product.updatedAt);

        final ProductResponse resp =
            await productService.editProduct(productEdit);

        if (resp.ok) {
          final productProvider =
              Provider.of<TabsViewScrollBLoC>(context, listen: false);

          productProvider.editProduct(this, resp.product);

          setState(() {
            loading = false;
          });

          showSnackBar(context, 'Producto editado con exito');

          Navigator.pop(context);
        }

        Navigator.pop(context);
      } else {
        showAlertError(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    } else {
      final productEdit = ProfileStoreProduct(
          id: widget.product.id,
          name: name,
          price: int.parse(price),
          description: description,
          images: imagesFinal,
          category: widget.product.category,
          user: store.user.uid,
          createdAt: widget.product.createdAt,
          updatedAt: widget.product.updatedAt);

      final ProductResponse resp =
          await productService.editProduct(productEdit);

      if (resp.ok) {
        final productProvider =
            Provider.of<TabsViewScrollBLoC>(context, listen: false);

        productProvider.editProduct(this, resp.product);

        setState(() {
          loading = false;
        });

        showSnackBar(context, 'Producto editado con exito');

        Navigator.pop(context);
      }

      Navigator.pop(context);
    }

    //final editCatalogoRes = await catalogoService.editCatalogo(editCategory);

    /*   if (editCatalogoRes != null) {
      if (editCatalogoRes.ok) {
        // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
        //  plantBloc.getPlant(widget.plant);
        setState(() {
          loading = false;
        });

        Navigator.pop(context);
      } else {
        showAlertError(context, 'Error', editCatalogoRes.msg);
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    } */

    //Navigator.pushReplacementNamed(context, '');
  }
}
