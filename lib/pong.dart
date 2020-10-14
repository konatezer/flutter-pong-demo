import 'package:flutter/material.dart';
import 'package:simple_pong/ball.dart';
import 'package:simple_pong/bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width;
  double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  // Animation variable
  Animation<double> animation;
  AnimationController animationController;
  // ball direction variable
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  // ball speed variable
  double ballSpeed = 5;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
    }
    if (posX >= height - 50 && hDir == Direction.down) {
      hDir = Direction.up;
    }
    if (posX <= 0 && hDir == Direction.up) {
      hDir = Direction.down;
    }
  }

  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;
    animationController = AnimationController(
      duration: Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(animationController);
    animation.addListener(() {
      setState(() {
        (hDir == Direction.right) ? posX += ballSpeed : posX -= ballSpeed;
        (vDir == Direction.down) ? posY += ballSpeed : posY -= ballSpeed;
      });
      checkBorders();
    });
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  void moveBat(DragUpdateDetails updateDetails) {
    setState(() {
      batPosition += updateDetails.delta.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batHeight = height / 20;
        batWidth = width / 5;
        return Stack(
          children: [
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) {
                  moveBat(update);
                },
                child: Bat(
                  width: batWidth,
                  height: batHeight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
