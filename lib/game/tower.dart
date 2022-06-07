import 'package:flame/components.dart';

class Tower extends SpriteComponent with HasGameRef {
  Tower()
      : super(
          size: Vector2(200, 400),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('tower.png');
    position = Vector2(10 * gameRef.size.x, gameRef.size.y - 80 - height);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}
