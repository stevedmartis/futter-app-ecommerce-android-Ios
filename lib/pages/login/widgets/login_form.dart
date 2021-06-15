import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'custom_button.dart';

import 'fade_slide_transition.dart';

class LoginForm extends StatelessWidget {
  final Animation<double> animation;

  const LoginForm({
    @required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final space = height > 650 ? kSpaceM : kSpaceS;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        children: <Widget>[
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 4 * space,
            child: CustomButton(
              color: Colors.black,
              textColor: kWhite,
              text: 'Continuar con  Apple',
              onPressed: () async {
                await _signIApple(context);
              },
              image: const Image(
                width: 50,
                image: AssetImage(kAppleLogoPath),
                height: 25.0,
              ),
            ),
          ),
          SizedBox(height: space),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 2 * space,
            child: CustomButton(
              color: kBlue,
              textColor: kWhite,
              text: 'Continuar con Google',
              onPressed: () {
                _signInGoogle(context);
              },
              image: const Image(
                width: 50,
                image: AssetImage(kGoogleLogoPath),
                height: 25.0,
              ),
            ),
          ),
          SizedBox(height: space),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 4 * space,
            child: CustomButton(
              isPhone: true,
              color: Colors.green,
              textColor: kWhite,
              text: 'Con tu número celular',
              onPressed: () {},
              image: const Icon(
                Icons.phone_iphone,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          SizedBox(height: space),
          /* FadeSlideTransition(
            animation: animation,
            additionalOffset: 2 * space,
            child: CustomButton(
              color: kBlue,
              textColor: kWhite,
              text: 'Login to continue',
              onPressed: () {},
            ),
          ), */
          //SizedBox(height: 2 * space),

          FadeSlideTransition(
            animation: animation,
            additionalOffset: 4 * space,
            child: Container(
              padding: EdgeInsets.only(left: 30),
              child: CustomButton(
                color: currentTheme.scaffoldBackgroundColor,
                textColor: Colors.white.withOpacity(0.5),
                text: 'Volver al Inicio',
                onPressed: () {
                  final menuBloc =
                      Provider.of<MenuModel>(context, listen: false);
                  menuBloc.currentPage = 0;
                  Navigator.push(context, principalHomeRoute());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _signIApple(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final signInAppleOk = await authService.appleSignIn(context);

    if (signInAppleOk) {
      socketService.connect();

      //  Provider.of<MenuModel>(context, listen: false).currentPage = 2;

      if (authService.redirect == 'profile' &&
          authService.storeAuth.user.first) {
        Navigator.push(context, profileEditRoute());
      } else if (authService.redirect == 'vender' &&
          authService.storeAuth.user.first) {
        Provider.of<MenuModel>(context, listen: false).currentPage = 2;
        Navigator.push(context, principalHomeRoute());
      }

      if (!authService.storeAuth.user.first) {
        Provider.of<MenuModel>(context, listen: false).currentPage = 0;
        Navigator.push(context, principalHomeRoute());
      }

      //Navigator.push(context, profileAuthRoute(true));
    } else {
      // Mostara alerta
      showAlertError(context, 'Login incorrecto', 'El correo ya existe');
    }

    //Navigator.pushReplacementNamed(context, '');
  }

  _signInGoogle(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final signInGoogleOk = await authService.signInWitchGoogle();

    if (signInGoogleOk) {
      if (authService.redirect == 'profile' &&
          authService.storeAuth.user.first) {
        Navigator.push(context, profileEditRoute());
      } else if (authService.redirect == 'vender' &&
          authService.storeAuth.user.first) {
        Provider.of<MenuModel>(context, listen: false).currentPage = 2;
        Navigator.push(context, principalHomeRoute());
      }

      if (!authService.storeAuth.user.first) {
        Provider.of<MenuModel>(context, listen: false).currentPage = 0;
        Navigator.push(context, principalHomeRoute());
      }
    } else {
      // Mostara alerta
      showAlertError(context, 'Login incorrecto', 'El correo ya existe');
    }
  }
}