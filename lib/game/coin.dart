import 'package:flame/components.dart';

class Coin extends SpriteComponent with HasGameRef {
  Coin()
      : super(
          size: Vector2.all(40),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('coin.png');
    position.x = 20;
    position.y = 20;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}
