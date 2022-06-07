import 'dart:math';
import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_game_mario/constants/enums.dart';

class CoinAnimation extends SpriteAnimationComponent with HasGameRef {
  late SpriteSheet spriteSheetDino;
  late GiftItem giftItem;
  Random random = Random();
  late int randomItem;

  @override
  Future<void>? onLoad() async {
    randomItem = random.nextInt(1000);
    giftItem = GiftItem.values[randomItem % 12 == 0 ? 1 : 0];

    if (giftItem == GiftItem.coin) {
      width = 40;
      height = 40;
      spriteSheetDino = SpriteSheet(
          image: await Images().load("coins.png"), srcSize: Vector2(35, 35));

      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 12,
      );
    } else if (giftItem == GiftItem.mashroom) {
      width = 35;
      height = 35;
      spriteSheetDino = SpriteSheet(
          image: await Images().load("mashroom.png"), srcSize: Vector2(35, 35));

      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 1,
      );
    }

    position = gameRef.size / 2;
    position.y -= 10;

    return super.onLoad();
  }

  makeRandom() async {
    randomItem = random.nextInt(1000);
    giftItem = GiftItem.values[randomItem % 12 == 0 ? 1 : 0];

    if (giftItem == GiftItem.coin) {
      spriteSheetDino = SpriteSheet(
          image: await Images().load("coins.png"), srcSize: Vector2(35, 35));

      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 12,
      );
    } else if (giftItem == GiftItem.mashroom) {
      width = 35;
      height = 35;
      spriteSheetDino = SpriteSheet(
          image: await Images().load("mashroom.png"), srcSize: Vector2(35, 35));

      animation = spriteSheetDino.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 1,
      );
    }
  }
}
