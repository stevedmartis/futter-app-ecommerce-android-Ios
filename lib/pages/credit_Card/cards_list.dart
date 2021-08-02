import 'package:australti_ecommerce_app/pages/credit_Card/data.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

class CreditCardListPage extends StatefulWidget {
  @override
  _CreditCardListPageState createState() => _CreditCardListPageState();
}

class _CreditCardListPageState extends State<CreditCardListPage> {
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
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
                    isAdd: true,
                    action: Container(),
                    //   Container()
                    onPress: () => {
                          HapticFeedback.lightImpact(),
                          /*  Navigator.of(context).push(
                                  createRouteAddEditCategory(
                                      category, false)), */
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

  Widget _buildCatalogoWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
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
            controller: PageController(viewportFraction: 0.9),
            physics: BouncingScrollPhysics(),
            itemCount: tarjetas.length,
            itemBuilder: (_, i) {
              final card = tarjetas[i];

              return Container(
                padding: EdgeInsets.only(
                  top: size.height / 6,
                ),
                child: GestureDetector(
                  onTap: () {
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
