class Album {
  const Album({
    this.artist,
    this.album,
    this.imageAlbum,
    this.imageDisc,
    this.description,
  });
  final String artist;
  final String album;
  final String imageAlbum;
  final String imageDisc;
  final String description;
}

final currentAlbum = Album(
  imageAlbum: 'assets/vinyl_album/album.jpg',
  imageDisc: 'assets/vinyl_album/vinyl.png',
  artist: 'Dexter Gordon',
  album: 'Our Man in Paris',
  description: r'''
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id ex nec orci rhoncus commodo. Morbi consequat, lacus non posuere ultricies, tortor urna dictum risus, a rutrum arcu nunc sit amet nisi. Vivamus tempor, nibh at semper pulvinar, justo magna eleifend nunc, nec semper quam tellus ac risus. Nunc tempus libero a nunc luctus facilisis. Nunc ut elementum orc.



  ''',
);
