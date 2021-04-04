import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter/rendering.dart';

import 'ingredient.dart';

class PizzaMetadata {
  const PizzaMetadata(this.imageBytes, this.position, this.size);
  final Uint8List imageBytes;
  final Offset position;
  final Size size;
}

enum PizzaSizeValue {
  s,
  m,
  l,
}

class PizzaSizeState {
  PizzaSizeState(this.value) : factor = _getFactorBySize(value);
  final PizzaSizeValue value;
  final double factor;

  static double _getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.75;
      case PizzaSizeValue.m:
        return 0.85;
      case PizzaSizeValue.l:
        return 1.0;
    }
    return 0.0;
  }
}

const initialTotal = 15;

class PizzaOrderBLoC extends ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(initialTotal);
  final notifierDeletedIngredient = ValueNotifier<Ingredient>(null);
  final notifierFocused = ValueNotifier(false);
  final notifierPizzaSize = ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final notifierPizzaBoxAnimation = ValueNotifier(false);
  final notifierImagePizza = ValueNotifier<PizzaMetadata>(null);
  final notifierCartIconAnimation = ValueNotifier(0);

  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    notifierTotal.value++;
  }

  void removeIngredient(Ingredient ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeletedIngredient.value = ingredient;
  }

  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value = null;
  }

  bool containsIngredient(Ingredient ingredient) {
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    notifierPizzaBoxAnimation.value = false;
    notifierImagePizza.value = null;
    listIngredients.clear();
    notifierTotal.value = initialTotal;
    notifierCartIconAnimation.value++;
  }

  void startPizzaBoxAnimation() {
    notifierPizzaBoxAnimation.value = true;
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierImagePizza.value = PizzaMetadata(byteData.buffer.asUint8List(), position, size);
  }
}
