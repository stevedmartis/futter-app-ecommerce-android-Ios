import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/responses/category_store_response.dart';
import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/utils.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateCategoryPage extends StatefulWidget {
  AddUpdateCategoryPage({this.category, this.isEdit = false, this.bloc});

  final ProfileStoreCategory category;
  final bool isEdit;
  final TabsViewScrollBLoC bloc;

  @override
  _AddUpdateCatalogoPageState createState() => _AddUpdateCatalogoPageState();
}

class _AddUpdateCatalogoPageState extends State<AddUpdateCategoryPage>
    with TickerProviderStateMixin {
  final nameCtrl = TextEditingController();

  final categoryBloc = CategoryBloc();

  final descriptionCtrl = TextEditingController();

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

  int index = 0;

  static List<String> values = ['Publico', 'Privado'];

  int selectedValue;
  @override
  void initState() {
    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.category.name;
    descriptionCtrl.text = widget.category.description;

    isSwitchedVisibility = widget.category.visibility;

    //  plantBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.category.name != nameCtrl.text)
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
        if (widget.category.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();

    descriptionCtrl.dispose();
    categoryBloc.dispose();

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
                'Editar catalogo',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              )
            : Text(
                'Crear catalogo',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
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
              // controller: _scrollController,
              slivers: <Widget>[
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _createName(),
                          SizedBox(
                            height: 20,
                          ),
                          _createDescription(),
                          SizedBox(
                            height: 20,
                          ),
                          _createVisibility(),
                          //_createPrivacity(),
                          /* Center(
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
        ),
      ),
    );
  }

  Widget _createName() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: categoryBloc.nameStream,
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
            onChanged: categoryBloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: categoryBloc.descriptionStream,
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
            onChanged: categoryBloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createVisibility() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: categoryBloc.privacityStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Publico',
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
            value: isSwitchedVisibility,
            onChanged: (value) {
              setState(() {
                isSwitchedVisibility = value;

                if (isSwitchedVisibility != widget.category.visibility) {
                  this.isVisibilityChange = true;
                } else {
                  this.isVisibilityChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget buildCustomPicker() => SizedBox(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 64,
          diameterRatio: 0.7,
          looping: true,
          onSelectedItemChanged: (index) => setState(() => this.index = index),
          // selectionOverlay: Container(),
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.pink.withOpacity(0.12),
          ),
          children: Utils.modelBuilder<String>(
            values,
            (index, value) {
              final isSelected = this.index == index;
              final color = isSelected ? Colors.pink : Colors.black;

              return Center(
                child: Text(
                  value,
                  style: TextStyle(color: color, fontSize: 24),
                ),
              );
            },
          ),
        ),
      );
/* 
  TextEditingController _controller = TextEditingController();
  Future<void> _selectedNumber(BuildContext context) async {
    int number = await showPicker();
  }
 */

  Widget _createButton(
    bool isControllerChange,
  ) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              (widget.isEdit) ? 'Guardar' : 'Crear',
              style: TextStyle(
                  color: (isControllerChange && !errorRequired)
                      ? currentTheme.accentColor
                      : Colors.grey,
                  fontSize: 18),
            ),
          ),
        ),
        onTap: isControllerChange && !errorRequired && !loading
            ? () => {
                  HapticFeedback.lightImpact(),
                  setState(() {
                    loading = true;
                  }),
                  FocusScope.of(context).unfocus(),
                  (widget.isEdit) ? _editCatalogo() : _createCatalogo(),
                }
            : null);
  }

  _createCatalogo() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final catalogoService =
        Provider.of<StoreCategoiesService>(context, listen: false);
    final bloc = Provider.of<TabsViewScrollBLoC>(context, listen: false);

    final name = (categoryBloc.name == null)
        ? widget.category.name
        : categoryBloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.category.description
        : categoryBloc.description.trim();

    final newCategory = ProfileStoreCategory(
        id: '2-c',
        store: authService.storeAuth,
        position: 0,
        name: name,
        visibility: isSwitchedVisibility,
        description: description,
        products: [],
        createdAt: authService.storeAuth.createdAt,
        updatedAt: authService.storeAuth.updatedAt);

    final CategoryResponse createCatalogoResp =
        await catalogoService.createCatalogo(newCategory);

    if (createCatalogoResp != null) {
      if (createCatalogoResp.ok) {
        loading = false;

        authService.storeAuth.user.first = false;

        authService.storeAuth = authService.storeAuth;

        bloc.addNewCategory(this, createCatalogoResp.category, context);

        Navigator.pop(context);
        setState(() {});
      } else {
        showAlertError(context, 'Error', 'Error');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editCatalogo() async {
    final catalogoService =
        Provider.of<StoreCategoiesService>(context, listen: false);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final bloc = Provider.of<TabsViewScrollBLoC>(context, listen: false);

    final description = (descriptionCtrl.text == "")
        ? widget.category.description
        : descriptionCtrl.text.trim();

    final editCategory = ProfileStoreCategory(
        id: widget.category.id,
        store: authService.storeAuth,
        position: 5,
        name: nameCtrl.text.trim(),
        visibility: isSwitchedVisibility,
        description: description,
        products: widget.category.products);

    final CategoryResponse editCatalogoRes =
        await catalogoService.editCatalogo(editCategory);

    if (editCatalogoRes != null) {
      if (editCatalogoRes.ok) {
        loading = false;

        bloc.editCategory(this, editCatalogoRes.category, context);

        Navigator.pop(context);
        setState(() {});
      } else {
        showAlertError(context, 'Error', 'Error');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }

    //Navigator.pushReplacementNamed(context, '');
  }
}

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(100, 42)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_time, size: 28),
            const SizedBox(width: 8),
            Text(
              'Show Picker',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        onPressed: onClicked,
      );
}
