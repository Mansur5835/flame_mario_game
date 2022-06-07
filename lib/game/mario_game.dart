import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_game_mario/game/box.dart';
import 'package:flame_game_mario/game/coin.dart';
import 'package:flame_game_mario/game/gift_animation.dart';
import 'package:flame_game_mario/game/enemy.dart';
import 'package:flame_game_mario/game/heart.dart';
import 'package:flame_game_mario/game/mario.dart';
import 'package:flutter/material.dart';
import '../constants/enums.dart';

class MarioGame extends FlameGame {
  bool gameOver = false;
  bool isShooting = false;
  bool shootingDirectionToL = false;
  int countCoin = 0;
  late TextComponent countCoinText;
  int hitCount = 3;
  bool hiting = true;
  bool isMarioBig = false;
  bool end = true;
  bool isJumping = false;
  double gravity = 100;

  SpriteAnimationComponent arrow = SpriteAnimationComponent();
  SpriteComponent parallax1 = SpriteComponent();
  CoinAnimation giftAnimation = CoinAnimation();
  SpriteComponent parallax2 = SpriteComponent();
  MashroomDirection mashroomDirection = MashroomDirection.none;
  Heart heart = Heart(count: 3);
  Mario mario = Mario();
  late SpriteAnimation spriteAnimationShootR;
  late SpriteAnimation spriteAnimationShootL;
  late SpriteAnimation spriteAnimationArrowR;
  late SpriteAnimation spriteAnimationArrowL;
  Box box = Box();
  Coin coin = Coin();
  Enemy enemy = Enemy();

  double marioSpeedY = 15;
  final textStyle = TextPaint(
      style: const TextStyle(
          color: Color.fromARGB(
            255,
            255,
            153,
            0,
          ),
          fontSize: 35));

  @override
  Future<void>? onLoad() async {
    //! component added
    await _marioAnimationsLoad();

    add(parallax1);
    add(parallax2);
    add(arrow);

    add(mario);
    add(enemy);

    add(giftAnimation);
    add(box);
    add(coin);
    add(countCoinText);
    add(heart);

    return super.onLoad();
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (gameOver) return;

    //! parallax(backgrount)  move
    _moveParallax();

    //! jump mario
    _onJumping();

    //! mario shooting
    _onShooting();

    //! move mashroom
    _moveMashroom();
  }

  _marioAnimationsLoad() async {
    final spriteSheet = SpriteSheet(
        image: await images.load("marios.png"), srcSize: Vector2(35, 35));
    final spriteSheetHitMario = SpriteSheet(
        image: await images.load("hits.png"), srcSize: Vector2(35, 35));

    final spriteSheetShootMario = SpriteSheet(
        image: await images.load("mario-shoot.png"), srcSize: Vector2(35, 35));

    countCoinText =
        TextComponent(text: countCoin.toString(), textRenderer: textStyle)
          ..size = Vector2.all(100)
          ..position = Vector2(80, 20);

    spriteAnimationShootR = spriteSheetShootMario.createAnimation(
      row: 0,
      stepTime: 0.05,
      to: 1,
    );

    spriteAnimationShootL = spriteSheetShootMario.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 3,
      to: 4,
    );

    spriteAnimationArrowR = spriteSheetShootMario.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 1,
      to: 2,
    );

    spriteAnimationArrowL = spriteSheetShootMario.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 2,
      to: 3,
    );

    arrow
      ..animation = spriteAnimationArrowR
      ..size = Vector2(35, 35)
      ..position = Vector2(-100, 0);

    parallax1
      ..sprite = await loadSprite("trees.jpg")
      ..size = size;

    parallax2
      ..sprite = await loadSprite("trees.jpg")
      ..size = size
      ..position.x = parallax1.width - 1;
  }

  jump() {
    isJumping = true;
    mario.directionJump = DirectionJump.up;
    mario.direction = DirectionRun.none;
  }

  _onJumping() {
    if (isJumping) {
      if (mario.directionJump == DirectionJump.up) {
        mario.y -= marioSpeedY;
        marioSpeedY = marioSpeedY / 1.1;
      }

      if (mario.directionJump == DirectionJump.down) {
        mario.y += marioSpeedY;
        marioSpeedY = marioSpeedY * 1.1;
      }

      if (marioSpeedY < 0.5) {
        mario.directionJump = DirectionJump.down;
      }

      if (box.x - 45 <= mario.x &&
          box.x + box.width > mario.x &&
          box.y + box.height - 20 >= mario.y) {
        mario.directionJump = DirectionJump.down;
        //! shift box
        _boxShifting();
      }

      if (mario.y >= size.y - 80 - mario.height) {
        isJumping = false;
        marioSpeedY = 15;
        mario.y = size.y - 80 - mario.height;
        makeDefould();
      }
    }
  }

  _boxShifting() async {
    box.y = box.y - 40;
    giftAnimation.y = giftAnimation.y - 40;

    await Future.delayed(Duration(milliseconds: 100));
    box.y = box.y + 40;
    if (giftAnimation.x > box.x - 40 && giftAnimation.x < box.x + 40) {
      if (giftAnimation.giftItem == GiftItem.mashroom) {
        mashroomDirection = MashroomDirection.right;
      } else {
        countCoin++;

        countCoinText
          ..text = countCoin.toString()
          ..size = Vector2.all(100)
          ..position = Vector2(80, 20);
      }
    }
    await Future.delayed(Duration(seconds: 2));

    if (giftAnimation.giftItem == GiftItem.mashroom) return;
    giftAnimation.makeRandom();

    giftAnimation.x = 2 * size.y + 200 + box.x + box.width + 8;

    giftAnimation.y = giftAnimation.y + 40;
  }

  _moveParallax() async {
    if (mario.direction == DirectionRun.right) {
      parallax1.x -= 3.5;
      parallax2.x -= 3.5;
      box.x -= 3.5;
      giftAnimation.x -= 3.5;
      enemy.x -= 3.5;
    } else if (mario.direction == DirectionRun.left) {
      parallax1.x += 3.5;
      parallax2.x += 3.5;
      box.x += 3.5;
      giftAnimation.x += 3.5;
      enemy.x += 3.5;
    }

    if (mario.x > enemy.x - 20 &&
        mario.x < enemy.x + 20 &&
        mario.y > enemy.y - 30) {
      if (hiting) {
        _marioHit();
      }
    }

    if (mario.x > enemy.x - 20 &&
        mario.x < enemy.x + 20 &&
        mario.y > enemy.y - 100 &&
        isMarioBig) {
      enemy.x = size.x + 200;

      enemy.makerRandom();
    }
    _bigMarioControl();

    _parallaxcontrol();
  }

  _parallaxcontrol() {
    if (parallax1.x < -parallax1.width) {
      parallax1.position.x = size.x - 5;
    }

    if (parallax2.x < -parallax2.width) {
      parallax2.position.x = size.x - 5;
    }

    if (parallax2.x > size.x) {
      parallax2.position.x = -size.x + 5;
    }

    if (box.x < -40) {
      box.x = 2 * size.y + 200;
      giftAnimation.x = 2 * size.y + 200;
    }
    if (enemy.x < -60) {
      enemy.x = size.x + 200;
      enemy.makerRandom();
    }

    if (parallax1.x > size.x) {
      parallax1.position.x = -size.x + 5;
    }
  }

  makeDefould() {
    end = true;
    mario.direction = DirectionRun.none;
    if (mario.animation == mario.spriteAnimationToRight ||
        mario.animation == mario.spriteAnimationHitL) {
      mario.animation = mario.spriteAnimationToNoneR;
    } else if (mario.animation == mario.spriteAnimationToLeft ||
        mario.animation == mario.spriteAnimationHitR) {
      mario.animation = mario.spriteAnimationToNoneL;
    }

    if (mario.animation == mario.spriteAnimationToUpL && !isJumping) {
      mario.animation = mario.spriteAnimationToNoneL;
    } else if (mario.animation == mario.spriteAnimationToUpR && !isJumping) {
      mario.animation = mario.spriteAnimationToNoneR;
    }
  }

  _marioDead() {
    overlays.add("game_over");
    gameOver = true;
    mario.animation = mario.spriteAnimationHit;
  }

  _marioHit() async {
    hiting = false;
    hitCount--;

    remove(heart);
    heart = Heart(count: hitCount);
    add(heart);

    if (hitCount <= 0) {
      _marioDead();
      return;
    }

    if (mario.animation == mario.spriteAnimationToLeft) {
      mario.animation = mario.spriteAnimationHitR;
      await Future.delayed(Duration(seconds: 1));
      if (!end) {
        mario.animation = mario.spriteAnimationToLeft;
      }
    } else if (mario.animation == mario.spriteAnimationToRight) {
      mario.animation = mario.spriteAnimationHitL;

      await Future.delayed(Duration(seconds: 1));
      if (!end) {
        mario.animation = mario.spriteAnimationToRight;
      }
    }
    hiting = true;
  }

  shootMario() async {
    isShooting = true;
    if (mario.animation == mario.spriteAnimationToNoneL) {
      shootingDirectionToL = true;
      mario.animation = spriteAnimationShootL;
      arrow
        ..animation = spriteAnimationArrowL
        ..size = Vector2(70, 70)
        ..position =
            Vector2(size.x / 2 - mario.width - 10, size.y - 80 - mario.height);
    } else if (mario.animation == mario.spriteAnimationToNoneR) {
      shootingDirectionToL = false;
      mario.animation = spriteAnimationShootR;

      arrow
        ..animation = spriteAnimationArrowR
        ..size = Vector2(70, 70)
        ..position =
            Vector2(size.x / 2 - mario.width + 10, size.y - 80 - mario.height);
    }

    Future.delayed(Duration(milliseconds: 200), () {
      if (mario.animation == spriteAnimationShootL) {
        mario.animation = mario.spriteAnimationToNoneL;
      } else if (mario.animation == spriteAnimationShootR) {
        mario.animation = mario.spriteAnimationToNoneR;
      }
    });
  }

  _onShooting() {
    if (isJumping) return;
    if (isShooting) {
      if (shootingDirectionToL) {
        arrow.x -= 10;
      } else {
        arrow.x += 10;
      }
    }

    if (arrow.x > size.x + 100 || arrow.x < -100) {
      arrow
        ..animation = spriteAnimationArrowR
        ..size = Vector2(35, 35)
        ..position = Vector2(-100, 0);
      isShooting = false;
    }

    if (arrow.x >= enemy.x && arrow.x < enemy.x + enemy.width - 40) {
      enemy.x = size.x + 200;
      arrow
        ..animation = spriteAnimationArrowR
        ..size = Vector2(35, 35)
        ..position = Vector2(-100, 0);
      isShooting = false;
      enemy.makerRandom();
    }
  }

  _moveMashroom() {
    if (mashroomDirection == MashroomDirection.right) {
      giftAnimation.x += 5;
      if (giftAnimation.x > box.x + 100) {
        mashroomDirection = MashroomDirection.down;
      }
    } else if (mashroomDirection == MashroomDirection.down) {
      giftAnimation.y += 5;
      if (giftAnimation.y >= size.y - 80 - giftAnimation.height) {
        giftAnimation.y = size.y - 80 - giftAnimation.height;
        mashroomDirection = MashroomDirection.none;
      }
    }
  }

  _bigMarioControl() async {
    if (mario.x > giftAnimation.x - 20 &&
        mario.x < giftAnimation.x + 20 &&
        mario.y < giftAnimation.y &&
        giftAnimation.giftItem == GiftItem.mashroom) {
      mario
        ..size = Vector2.all(100)
        ..position =
            Vector2(size.x / 2 - mario.width, size.y - 80 - mario.height);
      isMarioBig = true;

      giftAnimation.makeRandom();

      giftAnimation.x = 2 * size.y + 200 + box.x + box.width + 8;

      giftAnimation.y = box.y;

      await Future.delayed(Duration(seconds: 10));
      isMarioBig = false;

      mario
        ..size = Vector2.all(70)
        ..position =
            Vector2(size.x / 2 - mario.width, size.y - 80 - mario.height);
    }
  }

  startMove() {
    end = false;
  }
}
