import 'dart:math';

import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'pages/community/index.dart';

import 'pages/onboarding_page.dart';

import 'widgets/header.dart';
import 'widgets/next_page_button.dart';
import 'widgets/onboarding_page_indicator.dart';
import 'widgets/ripple.dart';

class Onboarding extends StatefulWidget {
  final double screenHeight;

  const Onboarding({
    @required this.screenHeight,
  });

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  AnimationController _cardsAnimationController;
  AnimationController _pageIndicatorAnimationController;
  AnimationController _rippleAnimationController;

  Animation<Offset> _slideAnimationLightCard;
  Animation<Offset> _slideAnimationDarkCard;
  Animation<double> _pageIndicatorAnimation;
  Animation<double> _rippleAnimation;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _cardsAnimationController = AnimationController(
      vsync: this,
      duration: kCardAnimationDuration,
    );
    _pageIndicatorAnimationController = AnimationController(
      vsync: this,
      duration: kButtonAnimationDuration,
    );
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.screenHeight,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.easeIn,
    ));

    _setPageIndicatorAnimation();
    _setCardsSlideOutAnimation();
  }

  @override
  void dispose() {
    _cardsAnimationController.dispose();
    _pageIndicatorAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }

  bool get isFirstPage => _currentPage == 1;

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return OnboardingPage(
          number: 1,
          lightCardChild: const CommunityLightCardContent(),
          darkCardChild: ImageContent(
            image: 'assets/on_board/e-Commerce.png',
          ),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: CommunityTextColumn(
            title: 'Vende en Freeily!',
            text:
                'Crea tu Tienda con tus catalogos y productos, recibe clientes, vende y gana!',
          ),
        );
      case 2:
        return OnboardingPage(
          number: 1,
          lightCardChild: const CommunityLightCardContent(),
          darkCardChild: ImageContent(
            image: 'assets/on_board/Courier.png',
          ),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: CommunityTextColumn(
            title: 'Haz delivery!',
            text:
                'Con repartidores sercanos entrega tus pedidos y gestiona el seguimiento.',
          ),
        );
      case 3:
        return OnboardingPage(
          number: 1,
          lightCardChild: const CommunityLightCardContent(),
          darkCardChild: ImageContent(
            image: 'assets/on_board/Money.png',
          ),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: CommunityTextColumn(
            title: 'Recibe tus pagos',
            text:
                'Con deposito bancario, efectivo o directo en tus tarjetas de credito, debito o virtuales',
          ),
        );
      default:
        throw Exception("Page with number '$_currentPage' does not exist.");
    }
  }

  void _setCardsSlideInAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: const Offset(3.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: const Offset(1.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setCardsSlideOutAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-3.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setPageIndicatorAnimation({bool isClockwiseAnimation = true}) {
    final multiplicator = isClockwiseAnimation ? 2 : -2;

    setState(() {
      _pageIndicatorAnimation = Tween(
        begin: 0.0,
        end: multiplicator * pi,
      ).animate(
        CurvedAnimation(
          parent: _pageIndicatorAnimationController,
          curve: Curves.easeIn,
        ),
      );
      _pageIndicatorAnimationController.reset();
    });
  }

  void _setNextPage(int nextPageNumber) {
    setState(() {
      _currentPage = nextPageNumber;
    });
  }

  Future<void> _nextPage() async {
    switch (_currentPage) {
      case 1:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(2);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
          _setCardsSlideOutAnimation();
          _setPageIndicatorAnimation(isClockwiseAnimation: false);
        }
        break;
      case 2:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(3);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
        }
        break;
      case 3:
        if (_pageIndicatorAnimation.status == AnimationStatus.completed) {
          await _goToLogin();
        }
        break;
    }
  }

  Future<void> _goToLogin() async {
    HapticFeedback.lightImpact();
    await _rippleAnimationController.forward();

    Navigator.of(context).push(selectCategoryObBoardStoreRoute());
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    Color gradientStart = Color(0xFF00FF00); //Change start gradient color here
    Color gradientEnd = currentTheme.primaryColor;
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingL),
                child: Column(
                  children: <Widget>[
                    Header(onSkip: _goToLogin),
                    Expanded(child: _getPage()),
                    AnimatedBuilder(
                      animation: _pageIndicatorAnimation,
                      builder: (_, Widget child) {
                        return OnboardingPageIndicator(
                          angle: _pageIndicatorAnimation.value,
                          currentPage: _currentPage,
                          child: child,
                        );
                      },
                      child: NextPageButton(
                        onPressed: _nextPage,
                        currentPage: _currentPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (_, Widget child) {
                return Ripple(radius: _rippleAnimation.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
