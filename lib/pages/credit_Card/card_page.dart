import 'package:freeily/models/credit_Card.dart';
import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/header_pages_custom.dart';
import 'package:freeily/widgets/show_alert_error.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:provider/provider.dart';
import '../../global/extension.dart';

class CardDetailPage extends StatefulWidget {
  CardDetailPage({this.creditCard});
  final CreditCard creditCard;
  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    Future.delayed(Duration.zero, () {
      showSnackBar(context, 'Se cambio la tarjeta de pagos');
    });

    prefs.setPyamentMethodCashOption = false;

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
              makeHeaderCustom(widget.creditCard.brand.capitalize()),
              SliverToBoxAdapter(
                  child: Stack(
                children: [
                  Hero(
                    tag: widget.creditCard.cardNumber,
                    child: CreditCardWidget(
                      cardBgColor: currentTheme.cardColor,
                      cardNumber: widget.creditCard.cardNumberHidden,
                      expiryDate: widget.creditCard.expiracyDate,
                      cardHolderName: widget.creditCard.cardHolderName,
                      cvvCode: widget.creditCard.cvv,
                      showBackView: false,
                    ),
                  ),
                ],
              ))
              //makeListProducts(context)
            ]),
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
                color: Colors.black,
                child: CustomAppBarHeaderPages(
                    showTitle: _showTitle,
                    title: title,
                    leading: true,
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
