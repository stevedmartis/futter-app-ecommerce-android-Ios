class NikeShoes {
  NikeShoes({
    this.model,
    this.oldPrice,
    this.currentPrice,
    this.images,
    this.modelNumber,
    this.color,
    this.size,
    this.description,
  });
  final String model;
  final double oldPrice;
  final double currentPrice;
  final List<String> images;
  final int modelNumber;
  final int color;
  final List<String> size;
  final String description;
}

final shoes = <NikeShoes>[
  NikeShoes(
    model: 'AIR MAX 90 EZ BLACK',
    currentPrice: 149,
    oldPrice: 299,
    images: [
      'assets/nike_shoes_store/shoes1_1.png',
      'assets/nike_shoes_store/shoes1_2.png',
      'assets/nike_shoes_store/shoes1_3.png'
    ],
    modelNumber: 90,
    color: 0xFFF6F6F6,
    size: ['6', '7', '9', '10', '10.5'],
    description: "The Air Max 90 doesn't just look cool, it also feels cool. "
        "With materials like leather, synthetic overlays, mesh, and/or suede "
        "creating the sneaker, the pair your kid chooses is as unique as they are. "
        "Padding in the collar allows for ankle stability, while numerous eyestays "
        "allow for different lacing options.",
  ),
  NikeShoes(
    model: 'AIR MAX 270 Gold',
    currentPrice: 199,
    oldPrice: 349,
    images: [
      'assets/nike_shoes_store/shoes2_1.png',
      'assets/nike_shoes_store/shoes2_2.png',
      'assets/nike_shoes_store/shoes2_3.png'
    ],
    modelNumber: 270,
    color: 0xFFFCF5EB,
    size: ['6', '7', '9', '9.5', '10'],
    description:
        "This sneaker isn't built for performance running, but rather, "
        "for making a stylish statement. Casual wear is the name of the "
        "game with the Nike Air Max 270. Once you take a look at the variety "
        "of fresh colorways, you’re going to want to add the Nike Air Max 270 "
        "into your wardrobe rotation ASAP. Choose between bright and bold "
        "hues, or go for the more classic colors depending on your OOTD.",
  ),
  NikeShoes(
    model: 'AIR MAX 95 Red',
    currentPrice: 299,
    oldPrice: 399,
    images: [
      'assets/nike_shoes_store/shoes3_1.png',
      'assets/nike_shoes_store/shoes3_2.png',
      'assets/nike_shoes_store/shoes3_3.png'
    ],
    modelNumber: 95,
    color: 0xFFFEEFEF,
    size: ['6', '7.5', '7', '8', '9'],
    description: "The Nike Air Max 95 is one of the most celebrated sneakers"
        " of all time. Since its debut in 1995, the design has been steadily "
        "gaining fans around the globe. To say it’s a timeless sneaker would be "
        "putting it mildly. Created by Nike designer Sergio Lozano, the "
        "Air Max 95 is important for its technology as much as its aesthetic. "
        "The shoe was the first to utilize visible Nike Air in the forefoot.",
  ),
  NikeShoes(
    model: 'AIR MAX 98 FREE',
    currentPrice: 149,
    oldPrice: 299,
    images: [
      'assets/nike_shoes_store/shoes4_1.png',
      'assets/nike_shoes_store/shoes4_2.png',
      'assets/nike_shoes_store/shoes4_3.png'
    ],
    modelNumber: 98,
    color: 0xFFEDF3FE,
    size: ['6', '7', '8', '9', '9.5'],
    description: "You won’t miss a beat when you step into a pair of "
        "Nike Air Max 98 sneakers. Capturing old-school charm with their natural "
        "retro appeal, they’re designed with all the features that characterize "
        "a quality shoe. Its impeccable construction makes for a stretchy and "
        "ultra-comfortable feel, while foam cushioning improves your response "
        "time and replicates the sensation of walking on a cloud. Coupled with "
        "ever-dependable Max Air cushioning, it’s a legendary shoe that delivers "
        "on all fronts.",
  ),
];
