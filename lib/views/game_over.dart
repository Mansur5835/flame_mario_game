import 'dart:io';

import 'package:flame_game_mario/screens/game_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GameOverWidget extends StatelessWidget {
  GameOverWidget({Key? key}) : super(key: key);
  final style = TextStyle(
      color: Colors.orangeAccent,
      fontFamily: "Rubik",
      fontSize: 25,
      fontWeight: FontWeight.bold);

  double backButton = 70;
  double reButton = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.1),
        body: Center(
          child: Container(
              width: 300,
              height: 200,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/buttons/dialog-board.png"))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "GAME OVER",
                    style: style,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => {backButton = 70});
                              exit(0);
                            },
                            onTapDown: (d) {
                              setState(() => {backButton = 65});
                            },
                            child: Image.asset(
                              "assets/buttons/back.png",
                              width: backButton,
                              height: backButton,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => {reButton = 70});

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (c) {
                                return GamePage();
                              }));
                            },
                            onTapDown: (d) {
                              setState(() => {reButton = 65});
                            },
                            child: Image.asset(
                              "assets/buttons/restart.png",
                              width: reButton,
                              height: reButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
