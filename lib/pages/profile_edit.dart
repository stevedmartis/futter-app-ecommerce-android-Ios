import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/store_profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/single_image_upload.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/product.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import "package:universal_html/html.dart" as html;

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  Store store;
  final storeProfileBloc = StoreProfileBloc();

  final picker = ImagePicker();

  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final lastName = TextEditingController();

  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  bool isUsernameChange = false;
  bool isNameChange = false;
  bool isAboutChange = false;
  bool isEmailChange = false;
  bool isPassChange = false;
  bool errorRequired = false;

  ImageUploadModel uploadImageFile;

  @override
  void initState() {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    store = authService.storeAuth;

    usernameCtrl.text = store.user.username;
    nameCtrl.text = store.name;
    aboutCtrl.text = store.about;

    emailCtrl.text = store.user.email;

    addressCtrl.text = store.address;
    cityCtrl.text = store.city;
    numberCtrl.text = store.number;

    usernameCtrl.addListener(() {
      setState(() {
        if (usernameCtrl.text != store.user.username)
          this.isUsernameChange = true;
        else
          this.isUsernameChange = false;

        if (usernameCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    nameCtrl.addListener(() {
      setState(() {
        if (store.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
        if (nameCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    aboutCtrl.addListener(() {
      setState(() {
        if (store.about != aboutCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });
    emailCtrl.addListener(() {
      setState(() {
        if (store.user.email != emailCtrl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;

        if (emailCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    passCtrl.addListener(() {
      setState(() {
        if (passCtrl.text.length >= 6)
          this.isPassChange = true;
        else
          this.isPassChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    lastName.dispose();
    aboutCtrl.dispose();

    super.dispose();
  }

  String uploadedImage = '';

  Future _onAddImageClick() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 680,
      maxWidth: 1800,
    );

    final File file = File(pickedFile.path);

    setState(() {
      getFileImage(0, file);
    });
  }

  void getFileImage(int index, File file) async {
//    var dir = await path_provider.getTemporaryDirectory();

    ImageUploadModel imageUpload = new ImageUploadModel();
    imageUpload.isUploaded = false;
    imageUpload.uploading = false;
    imageUpload.imageFile = file;
    imageUpload.imageUrl = '';
    uploadImageFile = imageUpload;

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    authService.imageProfileChange = true;

    Navigator.pop(context);
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final authService = Provider.of<AuthenticationBLoC>(context);

    final stripped = (uploadedImage != '')
        ? uploadedImage.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '')
        : '';

    final itemData = base64.decode(stripped);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [
            (!loading)
                ? _createButton(this.isUsernameChange, this.isAboutChange,
                    this.isEmailChange, this.isNameChange, this.isPassChange)
                : buildLoadingWidget(context),
          ],
          leading: (authService.redirect == 'profile')
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: currentTheme.currentTheme.accentColor,
                  ),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context),
                  color: Colors.white,
                )
              : Container(),
          title: Text(
            'Editar perfil',
            style: TextStyle(
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
          ),
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            //  _snapAppbar();
            // if (_scrollController.offset >= 250) {}
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverFixedExtentList(
                      itemExtent: 20,
                      delegate: SliverChildListDelegate([Container()])),
                  SliverFixedExtentList(
                      itemExtent: 170,
                      delegate: SliverChildListDelegate([
                        Column(
                          children: [
                            FadeIn(
                              child: Container(
                                child: (UniversalPlatform.isWeb)
                                    ? Center(
                                        child: Container(
                                            child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.black,
                                                child: GestureDetector(
                                                  onTap: () => {
                                                    // make changes here

                                                    //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                                                  },
                                                  child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      child: Hero(
                                                        tag: 'user_auth_avatar',
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      100.0)),
                                                          child: Image.memory(
                                                              itemData),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                      )
                                    : Container(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.black,
                                            child: GestureDetector(
                                              onTap: () => {
                                                // make changes here

                                                //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                                              },
                                              child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Hero(
                                                    tag: 'user_auth_avatar',
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.0)),
                                                      child: (uploadImageFile !=
                                                              null)
                                                          ? Image.file(
                                                              uploadImageFile
                                                                  .imageFile,
                                                              width: 150,
                                                              height: 150,
                                                            )
                                                          : (authService
                                                                      .storeAuth
                                                                      .imageAvatar !=
                                                                  "")
                                                              ? Container(
                                                                  child:
                                                                      cachedNetworkImage(
                                                                    authService
                                                                        .storeAuth
                                                                        .imageAvatar,
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  currentProfile
                                                                      .imageAvatar),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: StadiumBorder(),
                                child: Text(
                                  'Cambiar Foto Perfil',
                                  style: TextStyle(
                                      color:
                                          currentTheme.currentTheme.accentColor,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  final act = CupertinoActionSheet(
                                      title: Text('Cambiar Foto Perfil',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      actions: <Widget>[
                                        if (!UniversalPlatform.isWeb)
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              'Tomar Foto',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            onPressed: () {
                                              // _deleteProduct();
                                            },
                                          ),
                                        CupertinoActionSheetAction(
                                          child: Text(
                                            'Elegir de la galeria',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          onPressed: () {
                                            (UniversalPlatform.isWeb)
                                                ? _getImagesWeb()
                                                : _onAddImageClick();
                                            // _deleteProduct();
                                          },
                                        )
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ));
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) => act);
                                }),
                          ],
                        )
                      ])),
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        child: Column(
                          children: <Widget>[
                            _createName(nameCtrl),
                            SizedBox(
                              height: 10,
                            ),
                            _createUsername(usernameCtrl),
                            SizedBox(
                              height: 10,
                            ),

                            _createAbout(aboutCtrl),
                            SizedBox(
                              height: 10,
                            ),
                            // _createLastName(bloc),
                            _createEmail(emailCtrl),
                            SizedBox(
                              height: 10,
                            ),

                            _createAddress(),
                            SizedBox(
                              height: 10,
                            ),

                            _createCity(),
                            SizedBox(
                              height: 10,
                            ),
                            _createNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            _createPassword(passCtrl),
                            SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  List<html.File> files = [];
  List<int> imageFileBytes;
  List<int> _selectedFile;
  Uint8List _bytesData;
  bool isUpload = false;

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
      isUpload = true;
      uploadedImage = images[0];
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

    return filemMultiPart;
  }

  Widget _createButton(bool isUsernameChange, bool isAboutChange,
      bool isEmailChange, bool isNameChange, bool isPassChange) {
    return StreamBuilder(
      stream: storeProfileBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // final authService = Provider.of<AuthService>(context);
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        final productService = Provider.of<AuthenticationBLoC>(context);

        final isControllerChange = isUsernameChange ||
            isEmailChange ||
            isNameChange ||
            isPassChange ||
            isAboutChange;

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Guardar',
                  style: TextStyle(
                      color: (isControllerChange && !errorRequired ||
                              productService.isImageProfileChange)
                          ? currentTheme.accentColor
                          : Colors.grey.withOpacity(0.60),
                      fontSize: 18),
                ),
              ),
            ),
            onTap: (isControllerChange && !errorRequired ||
                    productService.isImageProfileChange)
                ? () => {
                      setState(() {
                        loading = true;
                      }),
                      FocusScope.of(context).unfocus(),
                      _editProfile()
                    }
                : null);
      },
    );
  }

  Widget _createEmail(TextEditingController emailCtl) {
    return StreamBuilder(
      stream: storeProfileBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: emailCtl,
            keyboardType: TextInputType.emailAddress,
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
                labelText: 'Email *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createUsername(TextEditingController usernameCtrl) {
    return StreamBuilder(
      stream: storeProfileBloc.usernameSteam,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: usernameCtrl,
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
                labelText: 'Nombre de usuario *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeUsername,
          ),
        );
      },
    );
  }

  Widget _createName(TextEditingController nameCtrl) {
    return StreamBuilder(
      stream: storeProfileBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: nameCtrl,
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
                labelText: 'Nombre',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createAddress() {
    return StreamBuilder(
      stream: storeProfileBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: addressCtrl,
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
                labelText: 'Calle y numero',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createCity() {
    return StreamBuilder(
      stream: storeProfileBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            enabled: false,
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: cityCtrl,
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
                labelText: 'Localidad',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createNumber() {
    return StreamBuilder(
      stream: storeProfileBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: numberCtrl,
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
                labelText: 'Numero',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createAbout(TextEditingController aboutCtrl) {
    return StreamBuilder(
      stream: storeProfileBloc.aboutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
              style: TextStyle(
                color: (currentTheme.customTheme) ? Colors.white : Colors.black,
              ),
              inputFormatters: [
                new LengthLimitingTextInputFormatter(148),
              ],
              controller: aboutCtrl,
              //  keyboardType: TextInputType.emailAddress,

              maxLines: 3,
              // any number you need (It works as the rows for the textarea)
              keyboardType: TextInputType.multiline,
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
                  labelText: 'Sobre mi',
                  //counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: storeProfileBloc.changeAbout),
        );
      },
    );
  }

  Widget _createPassword(TextEditingController passCtrl) {
    return StreamBuilder(
      stream: storeProfileBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: passCtrl,
            obscureText: true,
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
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: storeProfileBloc.changePassword,
          ),
        );
      },
    );
  }

  _editProfile() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeProfile = store;

    final username = usernameCtrl.text.trim();

    final name = nameCtrl.text.trim();

    final email = emailCtrl.text.trim();

    final password = passCtrl.text.trim();

    final about = aboutCtrl.text.trim();

    if (authService.isImageProfileChange) {
      final fileType = uploadImageFile.imageFile.path.split('.');

      final resp = await authService.uploadImageProfile(
          fileType[0], fileType[1], uploadImageFile.imageFile);

      if (resp != "") {
        final editProfileOk = await authService.editProfile(
            storeProfile.user.uid,
            username,
            about,
            name,
            email,
            password,
            resp);

        if (editProfileOk != null) {
          if (editProfileOk == true) {
            setState(() {
              loading = false;
            });

            showSnackBar(context, 'Perfil editado con exito!');
            if (storeProfile.user.first && authService.redirect == 'profile') {
              Navigator.push(context, profileAuthRoute(true));
            } else {
              Navigator.pop(context);
            }
          } else {
            showAlertError(context, 'Error', '');
          }
        } else {
          showAlertError(context, 'Error del servidor',
              'lo sentimos, Intentelo mas tarde');
        }
      }
    } else {
      final editProfileOk = await authService.editProfile(storeProfile.user.uid,
          username, about, name, email, password, storeProfile.imageAvatar);

      if (editProfileOk != null) {
        if (editProfileOk == true) {
          setState(() {
            loading = false;
          });

          showSnackBar(context, 'Perfil editado con exito!');
          if (storeProfile.user.first && authService.redirect == 'profile') {
            Navigator.push(context, profileAuthRoute(true));
          } else {
            Navigator.pop(context);
          }
        } else {
          showAlertError(context, 'Error', '');
        }
      } else {
        showAlertError(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
      //Navigator.pushReplacementNamed(context, '');
    }
  }
}
