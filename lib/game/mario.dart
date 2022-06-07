import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../constants/enums.dart';

class Mario extends SpriteAnimationComponent with HasGameRef {
  DirectionRun direction = DirectionRun.none;
  DirectionJump directionJump = DirectionJump.up;
  late SpriteSheet spriteSheet;
  late SpriteSheet spriteSheetHit;
  late SpriteAnimation spriteAnimationToRight;
  late SpriteAnimation spriteAnimationToLeft;
  late SpriteAnimation spriteAnimationToUpR;
  late SpriteAnimation spriteAnimationToUpL;
  late SpriteAnimation spriteAnimationToNoneL;
  late SpriteAnimation spriteAnimationToNoneR;
  late SpriteAnimation spriteAnimationHit;
  late SpriteAnimation spriteAnimationShootR;
  late SpriteAnimation spriteAnimationShootL;
  late SpriteAnimation spriteAnimationHitR;
  late SpriteAnimation spriteAnimationHitL;
  late SpriteAnimation spriteAnimationArrowR;
  late SpriteAnimation spriteAnimationArrowL;

  @override
  Future<void>? onLoad() async {
    spriteSheet = SpriteSheet(
        image: await Images().load("marios.png"), srcSize: Vector2(35, 35));

    spriteSheetHit = SpriteSheet(
        image: await Images().load("hits.png"), srcSize: Vector2(35, 35));

    spriteAnimationHitL = spriteSheetHit.createAnimation(
      row: 0,
      stepTime: 0.05,
      to: 2,
    );

    spriteAnimationHitR = spriteSheetHit.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 2,
      to: 4,
    );

    spriteAnimationToLeft = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 11,
      to: 21,
    );

    spriteAnimationToRight = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      to: 11,
    );

    spriteAnimationToLeft = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 11,
      to: 21,
    );
    spriteAnimationToNoneR = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 2,
      to: 3,
    );
    spriteAnimationToNoneL = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 14,
      to: 15,
    );
    spriteAnimationToUpR = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 23,
      to: 24,
    );
    spriteAnimationToUpL = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 25,
      to: 26,
    );

    spriteAnimationHit = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 22,
      to: 23,
    );

    animation = spriteAnimationToNoneR;

    size = Vector2(70, 70);

    position =
        Vector2(gameRef.size.x / 2 - width, gameRef.size.y - 80 - height);

    return super.onLoad();
  }
}
