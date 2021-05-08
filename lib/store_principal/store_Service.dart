class StoreService {
  const StoreService(
      {this.backImage, this.frontImage, this.name, this.stores, this.id});
  final int id;
  final String backImage;
  final String frontImage;
  final String name;
  final int stores;
}

final storeService = [
  StoreService(
      id: 1,
      backImage: 'assets/travel_photos/rest6.jpg',
      frontImage: 'assets/travel_photos/rest6.jpg',
      name: 'Restaurantes',
      stores: 50),
  StoreService(
      id: 2,
      backImage: 'assets/travel_photos/frutas_verduras3.jpeg',
      frontImage: 'assets/travel_photos/frutas_verduras3.jpeg',
      name: 'Mercados',
      stores: 20),
  StoreService(
      id: 3,
      backImage: 'assets/travel_photos/licores1.jpeg',
      frontImage: 'assets/travel_photos/licores1.jpeg',
      name: 'Licores',
      stores: 15),
/*   TravelPhoto(
      backImage: 'assets/travel_photos/south_korea_backImage.png',
      frontImage: 'assets/travel_photos/south_korea_frontImage.png',
      name: 'South Korea',
      photos: 1928),
  TravelPhoto(
      backImage: 'assets/travel_photos/thailand_backImage.png',
      frontImage: 'assets/travel_photos/thailand_frontImage.png',
      name: 'Thailand',
      photos: 638),
  TravelPhoto(
      backImage: 'assets/travel_photos/paris_backImage.png',
      frontImage: 'assets/travel_photos/paris_frontImage.png',
      name: 'Paris',
      photos: 845),
  TravelPhoto(
      backImage: 'assets/travel_photos/rome_backImage.png',
      frontImage: 'assets/travel_photos/rome_frontImage.png',
      name: 'Rome',
      photos: 231),
  TravelPhoto(
      backImage: 'assets/travel_photos/sydney_backImage.png',
      frontImage: 'assets/travel_photos/sydney_frontImage.png',
      name: 'Sydney',
      photos: 589) */
];
