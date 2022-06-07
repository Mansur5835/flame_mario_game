import 'package:flame/components.dart';

class Box extends SpriteComponent with HasGameRef {
  Box()
      : super(
          size: Vector2.all(35.0),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('podark.png');
    position = gameRef.size / 2;
    position.y -= 10;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}
