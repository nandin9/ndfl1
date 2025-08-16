// import 'package:flutter/material.dart';
import '../model/Texture.dart';

class Textures {

  List<Texture> list() {
    return <Texture> [
      Texture(
        name: 't1',
        path: 'assets/images/t1.jpg'
      ),
      Texture(
        name: 't2',
        path: 'assets/images/t2.jpg'
      ),
      Texture(
        name: 't3',
        path: 'assets/images/t3.jpg'
      )
    ];
  }
}
