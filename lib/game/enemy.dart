import 'dart:math';
import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef {
  Random random = Random();
  late SpriteSheet spriteSheetDino;
  late SpriteSheet spriteSheetPlant;
  int randomEnemy = 0;

  @override
  Future<void>? onLoad() async {
    spriteSheetDino = SpriteSheet(
        image: await Images().load("dino-enemy.png"), srcSize: Vector2(35, 35));

    spriteSheetPlant = SpriteSheet(
        image: await Images().load("plant-enemy.png"),
        srcSize: Vector2(35, 35));

    randomEnemy = random.nextInt(3);

    if (randomEnemy == 0) {
      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.3,
        to: 8,
      );
    } else if (randomEnemy == 1) {
      animation = spriteSheetPlant.createAnimation(
        row: 0,
        stepTime: 0.3,
        to: 3,
      );
    } else {
      animation = spriteSheetPlant.createAnimation(
        row: 0,
        stepTime: 0.3,
        from: 3,
        to: 6,
      );
    }

    width = 70;
    height = 70;

    position.x = gameRef.size.x;
    position.y = gameRef.size.y - 75 - height;

    return super.onLoad();
  }

  makerRandom() {
    randomEnemy = random.nextInt(3);

    if (randomEnemy == 0) {
      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.3,
        to: 8,
      );
    } else if (randomEnemy == 1) {
      animation = spriteSheetPlant.createAnimation(
        row: 0,
        stepTime: 0.3,
        to: 3,
      );
    } else {
      animation = spriteSheetPlant.createAnimation(
        row: 0,
        stepTime: 0.3,
        from: 3,
        to: 6,
      );
    }
  }
}
