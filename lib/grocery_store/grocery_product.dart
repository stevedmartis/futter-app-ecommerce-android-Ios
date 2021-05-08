class GroceryProduct {
  const GroceryProduct(
      {this.price,
      this.name,
      this.description,
      this.image,
      this.weight,
      this.user});
  final double price;
  final String name;
  final String description;
  final String image;
  final String weight;
  final String user;
}

const groceryProducts = <GroceryProduct>[
  GroceryProduct(
      user: '1-a',
      price: 8.30,
      name: 'Avocado',
      description:
          'The avocado is a fleshy exotic fruit obtained from the tropical tree of the same name. In some parts of South America it is known as Avocado.',
      image: 'assets/grocery_store/avocado.png',
      weight: '500g'),
  GroceryProduct(
      user: '1-a',
      price: 11.00,
      name: 'Banana',
      description:
          'It is a good fruit for everyone except diabetics and obese because of its high starch and sugar content.',
      image: 'assets/grocery_store/banana.png',
      weight: '1000g'),
  GroceryProduct(
      user: '1-a',
      price: 15.40,
      name: 'Mango',
      description:
          'Mango is recognized as one of the 3-4 finest tropical fruits. It is a fruit that is obtained from the tree of the same name.',
      image: 'assets/grocery_store/mango.png',
      weight: '500g'),
  GroceryProduct(
      user: '1',
      price: 4.15,
      name: 'Pineapple',
      description:
          'The tropical pineapple is the fruit obtained from the plant that receives the same name, Its shape is oval and thick.',
      image: 'assets/grocery_store/pineapple.png',
      weight: '1000g'),
  GroceryProduct(
      user: '1',
      price: 2.35,
      name: 'Cherry',
      description:
          'The cherry is a red fruit (drupe type) that comes from the cherry tree, a tree of the Rosaceae family, of the genus Prunus.',
      image: 'assets/grocery_store/cherry.png',
      weight: '500g'),
  GroceryProduct(
      user: '1',
      price: 6.15,
      name: 'Orange',
      description:
          'The orange is a hesperidium fruit (fleshy pulp between the endocarp and the seeds in the form of segments filled with juice).',
      image: 'assets/grocery_store/orange.png',
      weight: '1000g'),
];
