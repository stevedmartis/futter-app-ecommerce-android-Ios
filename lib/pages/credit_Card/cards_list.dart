import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/bloc/cards_services_bloc.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';
import 'package:freeily/models/credit_Card.dart';

import 'package:freeily/routes/routes.dart';
import 'package:freeily/services/stripe_service.dart';
import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/header_pages_custom.dart';
import 'package:freeily/widgets/show_alert_error.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreditCardListPage extends StatefulWidget {
  @override
  _CreditCardListPageState createState() => _CreditCardListPageState();
}

class _CreditCardListPageState extends State<CreditCardListPage> {
  final stripeService = new StripeService();

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();

    StripeService.init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;

  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              makeHeaderCustom('Mis tarjetas'),
              mekeListCreditCards(context)
              //makeListProducts(context)
            ]),
      ),
    );
  }

  SliverList mekeListCreditCards(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      CreditCardsList(),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();

    final cardBloc = Provider.of<CreditCardServices>(context);
    final bloc = Provider.of<GroceryStoreBLoC>(context);
    final authBloc = Provider.of<AuthenticationBLoC>(context);
    final totalFormat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(bloc.totalPriceElements());

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: CustomAppBarHeaderPages(
                    showTitle: _showTitle,
                    title: title,
                    leading: true,
                    isAdd: true,
                    action: Container(),
                    //   Container()
                    onPress: () async {
                      HapticFeedback.lightImpact();

                      showModalLoading(context);

                      final amount = totalFormat;
                      final currency = 'USD';

                      final resp = await this
                          .stripeService
                          .payWithNewCreditCard(
                              amount: amount, currency: currency);

                      Navigator.pop(context);

                      if (resp.id != '0') {
                        final respCard = await cardBloc.createNewCreditCard(
                            authBloc.storeAuth.user.uid, resp.id);

                        if (respCard.ok) {
                          if (cardBloc.myCards.length >
                              0) if (cardBloc.myCards[0] != null) {
                            CreditCard cardSelect = cardBloc.myCards
                                .firstWhere((item) => item.isSelect);

                            if (cardSelect != null) cardSelect.isSelect = false;
                          }
                          cardBloc.changeCardSelectToPay(respCard.card);
                          cardBloc.addNewCard(respCard.card);
                          prefs.setPyamentMethodCashOption = false;
                          showSnackBar(context, 'Tarjeta Agregada con exito');
                        } else {
                          showAlertError(context, 'Tarjeta existente.',
                              'Ya tienes una tarjeta con el mismo numero');
                        }
                      } else {
                        if (resp.customerId != 'cancel')
                          showSnackBar(context, 'Algo salió mal ');
                        Navigator.pop(context);
                      }
                    }))));
  }
}

class CreditCardsList extends StatefulWidget {
  @override
  _CreditCardsListState createState() => _CreditCardsListState();
}

class _CreditCardsListState extends State<CreditCardsList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width, height: size.height, child: _buildCatalogoWidget());
  }

  bool isCardChange = false;

  Widget _buildCatalogoWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final cardBloc = Provider.of<CreditCardServices>(context);

    final item = cardBloc.myCards.indexWhere(
      (item) => item.id == cardBloc.cardselectedToPay.value.id,
    );

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 30),
          child: Text(
            'Mis tarjetas',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: currentTheme.accentColor),
          ),
        ),
        PageView.builder(
            controller:
                PageController(viewportFraction: 0.9, initialPage: item),
            physics: BouncingScrollPhysics(),
            itemCount: cardBloc.myCards.length,
            itemBuilder: (_, i) {
              final card = cardBloc.myCards[i];

              return Container(
                padding: EdgeInsets.only(
                  top: size.height / 6,
                ),
                child: GestureDetector(
                  onTap: () {
                    prefs.setPyamentMethodCashOption = false;
                    cardBloc.cardselectedToPay.value = card;
                    Navigator.push(context, cardRouter(card));
                  },
                  child: Hero(
                    tag: card.cardNumber,
                    child: CreditCardWidget(
                      cardBgColor: currentTheme.cardColor,
                      cardNumber: card.cardNumberHidden,
                      expiryDate: card.expiracyDate,
                      cardHolderName: card.cardHolderName,
                      cvvCode: card.cvv,
                      showBackView: false,
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }
}
