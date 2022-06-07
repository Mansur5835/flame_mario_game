import 'package:flame/components.dart';

class Heart extends SpriteComponent with HasGameRef {
  int count;
  Heart({required this.count})
      : super(
          size: Vector2(70, 35),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('heart$count.png');

    position.x = gameRef.size.x / 2;
    position.y = 20;
  }
}
