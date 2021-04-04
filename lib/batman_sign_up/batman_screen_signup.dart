import 'package:flutter/material.dart';

import 'package:youtube_diegoveloper_challenges/batman_sign_up/batman_button.dart';

class BatmanScreenSignUp extends AnimatedWidget {
  BatmanScreenSignUp(
    Animation animation,
  ) : super(listenable: animation);
  Animation get _animationSignupIn => listenable as Animation;

  @override
  Widget build(BuildContext context) {
    return _animationSignupIn.value > 0
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Opacity(
              opacity: _animationSignupIn.value,
              child: Transform.translate(
                offset: Offset(0.0, 100 * (1 - _animationSignupIn.value)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'GET ACCESS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _BatmanInput(
                        label: 'FULL NAME',
                      ),
                      _BatmanInput(
                        label: 'EMAIL ID',
                      ),
                      _BatmanInput(
                        label: 'PASSWORD',
                        password: true,
                      ),
                      const SizedBox(height: 20),
                      BatmanButton(
                        text: 'SIGNUP',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _BatmanInput extends StatelessWidget {
  const _BatmanInput({
    Key key,
    this.label,
    this.password = false,
  }) : super(key: key);
  final String label;
  final bool password;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[800],
        width: 1.0,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            color: Colors.grey[800],
          ),
          enabledBorder: border,
          border: border,
          suffixIcon: password
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: UnconstrainedBox(
                    child: Image.asset(
                      'assets/batman_sign_up/batman_logo.png',
                      height: 15,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
