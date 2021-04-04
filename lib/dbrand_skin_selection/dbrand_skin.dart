import 'package:flutter/material.dart';

class DbrandSkin {
  const DbrandSkin({
    this.name,
    this.color,
    this.image,
    this.center = Alignment.center,
  });
  final String name;
  final int color;
  final String image;
  final Alignment center;
}

final skins = <DbrandSkin>[
  DbrandSkin(
    name: "Sunset Red",
    color: 0xFFE96B6A,
    image: "assets/dbrand_skin_selection/red.jpg",
  ),
  DbrandSkin(
    name: "Sunrise Orange",
    color: 0xFFFE9968,
    image: "assets/dbrand_skin_selection/orange.jpg",
    center: Alignment.bottomLeft,
  ),
  DbrandSkin(
    name: "Mellow Yellow",
    color: 0xFFFFD387,
    image: "assets/dbrand_skin_selection/yellow.jpg",
    center: Alignment.bottomRight,
  ),
  DbrandSkin(
    name: "Seafoam Green",
    color: 0xFF6CE5B1,
    image: "assets/dbrand_skin_selection/green.jpg",
    center: Alignment.topCenter,
  ),
  DbrandSkin(
    name: "Sky Blue",
    color: 0xFF7FE0EB,
    image: "assets/dbrand_skin_selection/blue.jpg",
    center: Alignment.topRight,
  ),
  DbrandSkin(
    name: "Kind of Purple",
    color: 0xFF98A2DF,
    image: "assets/dbrand_skin_selection/purple.jpg",
    center: Alignment.bottomCenter,
  ),
  DbrandSkin(
    name: "Off Pink",
    color: 0xFFEBB9D2,
    image: "assets/dbrand_skin_selection/pink.jpg",
  ),
  DbrandSkin(
    name: "Pastel Black",
    color: 0xFFD6D9D2,
    image: "assets/dbrand_skin_selection/pastel.jpg",
    center: Alignment.centerRight,
  ),
];
