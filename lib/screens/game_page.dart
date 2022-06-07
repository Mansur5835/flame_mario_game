import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game_mario/views/victory.dart';
import 'package:flutter/material.dart';

import '../constants/enums.dart';
import '../game/mario_game.dart';
import '../views/game_over.dart';
import '../views/joy_stick.dart';

class GamePage extends StatelessWidget {
  GamePage() {
    _fullScreen();
  }

  _fullScreen() async {
    await Flame.device.setLandscape();
  }

  @override
  Widget build(BuildContext context) {
    MarioGame marioGame = MarioGame();

    return Stack(
      children: [
        GameWidget(
            game: marioGame,
            initialActiveOverlays: [],
            overlayBuilderMap: {
              "game_over": (context, MarioGame mario) {
                return GameOverWidget();
              },
              "victory": (context, MarioGame mario) {
                return Victory();
              },
            }),
        Container(
          alignment: Alignment(1, 1),
          child: Container(
            width: 150,
            height: 150,
            child: JoystickView(
              onStart: (degrees, distance) {
                marioGame.startMove();
              },
              onEnd: ((degrees, distance) {
                print("END");
                marioGame.makeDefould();
              }),
              onDoubleTab: (d, f) {
                print("PRES");
                marioGame.shootMario();
              },
              toUpMove: (f, ff) {
                print("UP");

                if (marioGame.mario.animation ==
                        marioGame.mario.spriteAnimationToRight ||
                    marioGame.mario.animation ==
                        marioGame.mario.spriteAnimationToNoneR) {
                  marioGame.mario.animation =
                      marioGame.mario.spriteAnimationToUpR;
                } else if (marioGame.mario.animation ==
                        marioGame.mario.spriteAnimationToLeft ||
                    marioGame.mario.animation ==
                        marioGame.mario.spriteAnimationToNoneL) {
                  marioGame.mario.animation =
                      marioGame.mario.spriteAnimationToUpL;
                }

                marioGame.jump();
              },
              toLeftMove: (f, ff) {
                print("LEFT");

                marioGame.mario.direction = DirectionRun.left;
                marioGame.mario.animation =
                    marioGame.mario.spriteAnimationToLeft;
              },
              toRightMove: (f, ff) {
                print("RIGHt");

                marioGame.mario.animation =
                    marioGame.mario.spriteAnimationToRight;

                marioGame.mario.direction = DirectionRun.right;
              },
              toDowntMove: (f, ff) {
                print("DOWN");
              },
              backgroundColor:
                  Color.fromARGB(255, 116, 116, 116).withOpacity(0.4),
              innerCircleColor: Color.fromARGB(255, 189, 189, 189),
              size: 150,
            ),
          ),
        ),
      ],
    );
  }
}
