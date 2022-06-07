import 'package:flame_game_mario/screens/game_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offset;
  late Offset local;
  double startButtonWidth = 300;
  double marginButton = 0;
  final style = const TextStyle(
      color: Colors.white,
      fontFamily: "Rubik",
      fontSize: 50,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 10, color: Colors.red, offset: Offset(10, 0))
      ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    offset = Tween<Offset>(
      begin: const Offset(3, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate))
      ..addListener(() {
        print(offset);
        setState(() {});
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    marginButton = MediaQuery.of(context).size.width / 6;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/mario-back.jpg"))),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Lottie.asset("assets/lotties/mario.json",
                  repeat: true, reverse: true),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Mario",
                style: style,
                overflow: TextOverflow.fade,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    startButtonWidth = 300;
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return GamePage();
                  }));
                },
                onTapDown: (d) {
                  setState(() {
                    startButtonWidth = 290;
                  });
                },
                child: SlideTransition(
                  position: offset,
                  child: Image.asset(
                    "assets/buttons/start-button.png",
                    fit: BoxFit.cover,
                    width: startButtonWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
