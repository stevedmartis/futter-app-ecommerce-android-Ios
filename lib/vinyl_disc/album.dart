class Profile {
  const Profile({
    this.name,
    this.username,
    this.imageAvatar,
    this.description,
  });
  final String name;
  final String username;
  final String imageAvatar;
  final String description;
}

final currentProfile = Profile(
  imageAvatar: 'assets/vinyl_album/album.jpg',
  name: 'Dexter Gordon',
  username: 'dexter.gordon',
  description: r'''
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id ex nec orci rhoncus commodo. Morbi consequat, lacus non posuere ultricies, tortor urna dictum risus, a rutrum arcu nunc sit amet nisi. Vivamus tempor, nibh at semper pulvinar, justo magna eleifend nunc, nec semper quam tellus ac risu. 
  ''',
);
