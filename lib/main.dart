import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(GameWidget(game: PrefGame()));
}

class PrefGame extends FlameGame with HasTappables {
  int counter = 0;
  TextComponent score = TextBoxComponent();
  final mainPaint = TextPaint(
      style: const TextStyle(
          color: Colors.black, fontSize: 36, fontFamily: 'Arcade'));
  bool reset = false;
  late final SharedPreferences prefs;

  @override
  Color backgroundColor() => const Color(0xff7febe0);

  @override
  FutureOr<void> onLoad() async {
    prefs = await SharedPreferences.getInstance();

    counter = prefs.getInt('counter') ?? 0;
    score.textRenderer = mainPaint;
    add(score);
    add(
      ButtonComponent(
        button: TextComponent(text: ' add ', textRenderer: mainPaint),
        position: Vector2(150, 0),
        onPressed: () {
          add(CatComponent()..position = Vector2(150.0 * counter, 200.0));

          counter++;
          prefs.setInt('counter', counter);
        },
      ),
    );
    add(
      ButtonComponent(
        button: TextComponent(text: ' reset ', textRenderer: mainPaint),
        position: Vector2(250, 0),
        onPressed: () {
          counter = 0;
          prefs.setInt('counter', counter);
          reset = true;
        },
      ),
    );

    showCats();

    return super.onLoad();
  }

  void showCats() {
    counter = prefs.getInt('counter') ?? 0;
    for (int i = 0; i < counter; i++) {
      add(CatComponent()..position = Vector2(150.0 * i, 200.0));
    }
  }

  @override
  void update(double dt) {
    score.text = 'cats: $counter';
    if (reset) {
      final allCats = children.query<CatComponent>();
      removeAll(allCats);
      reset = false;
    }
    super.update(dt);
  }
}

class CatComponent extends SpriteComponent with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('cat.png', srcSize: Vector2.all(32.0));
    size = Vector2.all(32) * 4;
    return super.onLoad();
  }
}
