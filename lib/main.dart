import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_rect/animtions/page_routing/first_page.dart';
import 'package:game_rect/animtions/random_color.dart';
import 'package:game_rect/background_color.dart';
import 'package:game_rect/rect_color.dart';
import 'package:game_rect/rect_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectRectangleShape(),
    );
  }
}
