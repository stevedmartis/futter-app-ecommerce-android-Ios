import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/cards_services_bloc.dart';

import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/credit_Card.dart';

import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_product.dart';

import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';

import 'package:australti_ecommerce_app/services/stripe_service.dart';

import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';

class PaymentMethosOptionsPage extends StatefulWidget {
  PaymentMethosOptionsPage(this.orderPage);
  final bool orderPage;

  @override
  _PaymentMethosOptionsPageState createState() =>
      _PaymentMethosOptionsPageState();
}

Store storeAuth;

class _PaymentMethosOptionsPageState extends State<PaymentMethosOptionsPage> {
  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool loading = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();

    StripeService.init();
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  TabController controller;

  int itemCount;
  IndexedWidgetBuilder tabBuilder;
  IndexedWidgetBuilder pageBuilder;
  Widget stub;
  ValueChanged<int> onPositionChange;
  ValueChanged<double> onScroll;
  int initPosition;
  bool isFallow;

  List<ProfileStoreProduct> productsByCategoryList = [];

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,

        // tab bar view
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            return false;
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Metodo de pago'),
                makeListOptions(loading, widget.orderPage)
              ]),
        ),
      ),
    );
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
                child: Container(
                    child: CustomAppBarHeaderPages(
              showTitle: _showTitle,
              title: title,
              leading: true,
              action: Container(),
              onPress: () => {
/*                         Navigator.of(context).push(createRouteAddEditProduct(
                            product, false, widget.category)), */
              },
            )))));
  }
}

SliverList makeListOptions(bool loading, bool orderPage) {
  return SliverList(
    delegate: SliverChildListDelegate([
      Container(
          child: OptionsList(
        loading: loading,
        orderPage: orderPage,
      )),
    ]),
  );
}

class OptionsList extends StatefulWidget {
  const OptionsList({Key key, this.loading, this.orderPage}) : super(key: key);

  final bool loading;
  final bool orderPage;

  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  List<Order> orders = [];
  bool loading = false;

  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Selecciona una opción',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Container(
            child: Text(
              'Eligue con que metodo pagaras el pedido.',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          SizedBox(
            height: 20,
          ),
          /*  SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FadeIn(
                child: CreditCardOption(),
              ),
            ),
          ), */
          /*  SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FadeIn(
                child: MyCreditsCardOption(),
              ),
            ),
          ), */
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FadeIn(
                child: CashOption(
                  orderPage: widget.orderPage,
                ),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FadeIn(
                child: BankAccountOption(
                  orderPage: widget.orderPage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreditCardOption extends StatefulWidget {
  CreditCardOption();

  @override
  _CreditCardOptionState createState() => _CreditCardOptionState();
}

class _CreditCardOptionState extends State<CreditCardOption> {
  final stripeService = new StripeService();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final cardBloc = Provider.of<CreditCardServices>(context);
    final authBloc = Provider.of<AuthenticationBLoC>(context);
    final bloc = Provider.of<GroceryStoreBLoC>(context);
    final totalFormat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(bloc.totalPriceElements());

    void newCreditCard() async {
      HapticFeedback.lightImpact();

      showModalLoading(context);

      final amount = totalFormat;
      final currency = 'USD';

      final resp = await this
          .stripeService
          .payWithNewCreditCard(amount: amount, currency: currency);

      if (resp.id != '0') {
        final respCard = await cardBloc.createNewCreditCard(
            authBloc.storeAuth.user.uid, resp.id);

        // cardBloc.addNewCard()

        if (respCard.ok) {
          if (cardBloc.myCards.length > 0) {
            CreditCard cardSelect =
                cardBloc.myCards.firstWhere((item) => item.isSelect);

            if (cardSelect != null) cardSelect.isSelect = false;
          }
          Navigator.pop(context);
          cardBloc.addNewCard(respCard.card);
          cardBloc.changeCardSelectToPay(respCard.card);
          prefs.setPyamentMethodCashOption = false;
          Navigator.push(context, orderDetailRoute());
          showSnackBar(context, 'Tarjeta Agregada con exito');
        } else {
          showAlertError(context, 'Tarjeta existente.',
              'Ya tienes una tarjeta con el mismo numero');
        }
      } else {
        if (resp.customerId != 'cancel') {
          showSnackBar(context, 'Algo salió mal ');
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      }
    }

    return GestureDetector(
      onTap: () => newCreditCard(),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: Icon(
                          Icons.credit_card,
                          size: 30,
                          color: currentTheme.accentColor,
                        ),
                      )),
                  Container(
                    child: Text(
                      'Tarjeta de credito',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () => newCreditCard(),
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: currentTheme.primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCreditsCardOption extends StatelessWidget {
  MyCreditsCardOption();

  final stripeService = new StripeService();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return GestureDetector(
      onTap: () => Navigator.push(context, myCardsRoute()),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: Icon(
                          Icons.payments,
                          size: 30,
                          color: currentTheme.accentColor,
                        ),
                      )),
                  Container(
                    child: Text(
                      'Mis tarjetas',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () => Navigator.push(context, myCardsRoute()),
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: currentTheme.primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CashOption extends StatelessWidget {
  CashOption({this.orderPage});
  final bool orderPage;
  final stripeService = new StripeService();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final cardBloc = Provider.of<CreditCardServices>(context);

    final cardCash = CreditCard(
        id: '0',
        cardNumber: '0',
        cardHolderName: 'Efectivo',
        brand: 'cash',
        cardNumberHidden: '0');
    return GestureDetector(
      onTap: () {
        cardBloc.changeCardSelectToPay(cardCash);
        if (orderPage) {
          Navigator.push(context, orderDetailRoute());
        } else {
          Navigator.pop(context);
        }
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: Icon(
                          Icons.attach_money,
                          size: 30,
                          color: currentTheme.accentColor,
                        ),
                      )),
                  Container(
                    child: Text(
                      'Dinero en efectivo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: currentTheme.primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* class _ProfileStoreCategoryItem extends StatelessWidget {
  const _ProfileStoreCategoryItem(this.category);
  final ProfileStoreCategory category;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category.name,
        style: TextStyle(
          color: (!currentTheme.customTheme) ? Colors.black54 : Colors.white54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} */

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
            SizedBox(width: 10),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Search product ...',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class BankAccountOption extends StatelessWidget {
  BankAccountOption({this.orderPage});
  final bool orderPage;
  final stripeService = new StripeService();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final cardBloc = Provider.of<CreditCardServices>(context);

    final cardCash = CreditCard(
        id: '1',
        cardNumber: '1',
        cardHolderName: 'Deposito',
        brand: 'bank',
        cardNumberHidden: '1');
    return GestureDetector(
      onTap: () {
        cardBloc.changeCardSelectToPay(cardCash);
        if (orderPage) {
          Navigator.push(context, orderDetailRoute());
        } else {
          Navigator.push(context, bankAccountStorePayment(false));
        }
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: Icon(
                          Icons.account_balance,
                          size: 30,
                          color: currentTheme.accentColor,
                        ),
                      )),
                  Container(
                    child: Text(
                      'Deposito bancario',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: currentTheme.primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Route createRouteAddEditProduct(
    ProfileStoreProduct product, bool isEdit, String category) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateProductPage(
            product: product, isEdit: isEdit, category: category),
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
