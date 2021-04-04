class City {
  const City({
    this.name,
    this.price,
    this.place,
    this.date,
    this.image,
    this.reviews,
  });
  final String name;
  final String price;
  final String place;
  final String date;
  final String image;
  final List<CityReview> reviews;
}

class CityReview {
  const CityReview({
    this.avatar,
    this.date,
    this.title,
    this.subtitle,
    this.description,
    this.image,
  });
  final String avatar;
  final DateTime date;
  final String title;
  final String subtitle;
  final String description;
  final String image;
}

final cities = <City>[
  City(
      name: 'Tokyo',
      price: '580USD',
      place: 'Cyberpunk',
      date: '2015/03/22',
      image: 'assets/multiple_card_flow/banner_tokyo.jpg',
      reviews: [
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_tokyo.jpg',
            date: DateTime(2015, 3, 22, 7, 0, 0),
            title: 'Asakusa a district of Taito',
            subtitle: 'We travel not to escape life...',
            description:
                'Asakusa retains the essence of an older Tokyo, with traditional craft shops and street food stalls on Nakamise Street...',
            image: 'assets/multiple_card_flow/review_tokyo.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_tokyo.jpg',
            date: DateTime(2015, 3, 22, 7, 0, 0),
            title: 'Asakusa a district of Taito2',
            subtitle: 'We travel not to escape life...',
            description:
                'Asakusa retains the essence of an older Tokyo, with traditional craft shops and street food stalls on Nakamise Street...',
            image: 'assets/multiple_card_flow/review_tokyo.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_tokyo.jpg',
            date: DateTime(2015, 3, 22, 7, 0, 0),
            title: 'Asakusa a district of Taito3',
            subtitle: 'We travel not to escape life...',
            description:
                'Asakusa retains the essence of an older Tokyo, with traditional craft shops and street food stalls on Nakamise Street...',
            image: 'assets/multiple_card_flow/review_tokyo.jpg'),
      ]),
  City(
      name: 'New York',
      price: '470USD',
      place: 'Empire State',
      date: '2016/09/17',
      image: 'assets/multiple_card_flow/banner_newyork.jpg',
      reviews: [
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_newyork.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Broad,wholesomemcharitable',
            subtitle: 'We travel not to escape life...',
            description:
                'Broad,wholesome,charitable views of men and things cannot be acquired by vegetating in one little corner of the ...',
            image: 'assets/multiple_card_flow/review_newyork.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_newyork.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Broad,wholesomemcharitable2',
            subtitle: 'We travel not to escape life...',
            description:
                'Broad,wholesome,charitable views of men and things cannot be acquired by vegetating in one little corner of the ...',
            image: 'assets/multiple_card_flow/review_newyork.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_newyork.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Broad,wholesomemcharitable3',
            subtitle: 'We travel not to escape life...',
            description:
                'Broad,wholesome,charitable views of men and things cannot be acquired by vegetating in one little corner of the ...',
            image: 'assets/multiple_card_flow/review_newyork.jpg')
      ]),
  City(
      name: 'PARIS',
      price: '470USD',
      place: 'The Eiffel Tower',
      date: '2016/09/07',
      image: 'assets/multiple_card_flow/banner_paris.jpg',
      reviews: [
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_paris.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Vajrasana retreat centre review',
            subtitle: 'Waisham-le-Willows',
            description:
                'It is architecture that fades into the backg-round, allowing your mind to concentrate on higher things.',
            image: 'assets/multiple_card_flow/review_paris.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_paris.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Vajrasana retreat centre review2',
            subtitle: 'Waisham-le-Willows',
            description:
                'It is architecture that fades into the backg-round, allowing your mind to concentrate on higher things.',
            image: 'assets/multiple_card_flow/review_paris.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_paris.jpg',
            date: DateTime(2016, 3, 2, 7, 0, 0),
            title: 'Vajrasana retreat centre review3',
            subtitle: 'Waisham-le-Willows',
            description:
                'It is architecture that fades into the backg-round, allowing your mind to concentrate on higher things.',
            image: 'assets/multiple_card_flow/review_paris.jpg')
      ]),
  City(
      name: 'Italy',
      price: '830USD',
      place: 'Rome Coliseum',
      date: '2014/08/08',
      image: 'assets/multiple_card_flow/banner_italy.jpg',
      reviews: [
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_italy.jpg',
            date: DateTime(2014, 8, 8, 7, 0, 0),
            title: 'Manarola is a small town',
            subtitle: 'We travel not to escape life...',
            description:
                'Manarola primary industries have traditionally been fishing and viticulture. The local wine, called Sciacchetrà, is especially renowned...',
            image: 'assets/multiple_card_flow/review_italy.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_italy.jpg',
            date: DateTime(2014, 8, 8, 7, 0, 0),
            title: 'Manarola is a small town2',
            subtitle: 'We travel not to escape life...',
            description:
                'Manarola primary industries have traditionally been fishing and viticulture. The local wine, called Sciacchetrà, is especially renowned...',
            image: 'assets/multiple_card_flow/review_italy.jpg'),
        CityReview(
            avatar: 'assets/multiple_card_flow/avatar_italy.jpg',
            date: DateTime(2014, 8, 8, 7, 0, 0),
            title: 'Manarola is a small town3',
            subtitle: 'We travel not to escape life...',
            description:
                'Manarola primary industries have traditionally been fishing and viticulture. The local wine, called Sciacchetrà, is especially renowned...',
            image: 'assets/multiple_card_flow/review_italy.jpg')
      ])
];
