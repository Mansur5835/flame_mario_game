import 'dart:math' as _math;
import 'package:flutter/material.dart';

typedef JoystickDirectionCallback = void Function(
    double degrees, double distance);

class JoystickView extends StatelessWidget {
  final double? size;
  final Color? iconsColor;
  final Color? backgroundColor;
  final Color? innerCircleColor;
  final double? opacity;
  final JoystickDirectionCallback? onDoubleTab;
  final JoystickDirectionCallback? onStart;
  final JoystickDirectionCallback? onEnd;
  final JoystickDirectionCallback? toUpMove;
  final JoystickDirectionCallback? toLeftMove;
  final JoystickDirectionCallback? toRightMove;
  final JoystickDirectionCallback? toDowntMove;
  final Duration? interval;
  final bool? showArrows;
  JoystickView(
      {this.size,
      required this.toUpMove,
      required this.onStart,
      required this.toRightMove,
      required this.toLeftMove,
      required this.toDowntMove,
      required this.onDoubleTab,
      required this.onEnd,
      this.iconsColor = Colors.white54,
      this.backgroundColor = Colors.blueGrey,
      this.innerCircleColor = Colors.blueGrey,
      this.opacity,
      this.interval,
      this.showArrows = true});

  bool controlRolikUp = false;
  bool controlRolikDown = false;
  bool controlRolikLeft = false;
  bool controlRolikRight = false;

  @override
  Widget build(BuildContext context) {
    double actualSize = size != null
        ? size!
        : _math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double innerCircleSize = actualSize / 2;
    Offset lastPosition = Offset(innerCircleSize, innerCircleSize);
    Offset joystickInnerPosition = _calculatePositionOfInnerCircle(
        lastPosition, innerCircleSize, actualSize, Offset(0, 0));
    return Center(
      child: StatefulBuilder(
        builder: (context, setState) {
          Widget joystick = Stack(
            children: <Widget>[
              CircleView.joystickCircle(
                actualSize,
                backgroundColor ?? Colors.green,
              ),
              Positioned(
                child: CircleView.joystickInnerCircle(
                  actualSize / 2,
                  innerCircleColor!,
                ),
                top: joystickInnerPosition.dy,
                left: joystickInnerPosition.dx,
              ),
            ],
          );

          return GestureDetector(
            onTapDown: (d) {
              onStart!(0, 0);
            },
            onPanStart: (details) {
              // onPressed!(0, 0);

              // _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
              //     details.localPosition, _callbackTimestamp!);
              setState(() => lastPosition = details.localPosition);
            },
            onDoubleTap: () {
              onDoubleTab!(0, 0);
            },
            onPanEnd: (details) {
              setState(() {
                controlRolikRight = false;
                controlRolikUp = false;
                controlRolikLeft = false;
                controlRolikDown = false;
              });

              onEnd!(0, 0);

              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  Offset(innerCircleSize, innerCircleSize),
                  innerCircleSize,
                  actualSize,
                  Offset(0, 0));
              setState(() =>
                  lastPosition = Offset(innerCircleSize, innerCircleSize));
            },
            onPanUpdate: (details) {
              // _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
              //     details.localPosition, _callbackTimestamp!);
              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  lastPosition,
                  innerCircleSize,
                  actualSize,
                  details.localPosition);
              setState(() => lastPosition = details.localPosition);
              double x = details.localPosition.dx;
              double y = details.localPosition.dy;

              if (x >= 60 && x <= 80 && y < 40) {
                controlRolikDown = false;
                controlRolikRight = false;
                controlRolikLeft = false;

                if (!controlRolikUp) {
                  toUpMove!(0, 0);
                }

                controlRolikUp = true;
              } else if (x >= 60 && x <= 80 && y > 110) {
                controlRolikUp = false;
                controlRolikRight = false;
                controlRolikLeft = false;

                if (!controlRolikDown) {
                  toDowntMove!(0, 0);
                }

                controlRolikDown = true;
              } else if (x < 40 && y > 60 && y < 100) {
                controlRolikUp = false;
                controlRolikRight = false;
                controlRolikDown = false;
                if (!controlRolikLeft) {
                  toLeftMove!(0, 0);
                }
                controlRolikLeft = true;
              } else if (x > 95 && y > 60 && y < 100) {
                controlRolikUp = false;
                controlRolikLeft = false;
                controlRolikDown = false;
                if (!controlRolikRight) {
                  toRightMove!(0, 0);
                }

                controlRolikRight = true;
              }
            },
            child: (opacity != null)
                ? Opacity(opacity: opacity!, child: joystick)
                : joystick,
          );
        },
      ),
    );
  }

  bool _canCallOnDirectionChanged(DateTime callbackTimestamp) {
    if (interval != null && callbackTimestamp != null) {
      int intervalMilliseconds = interval!.inMilliseconds;
      int timestampMilliseconds = callbackTimestamp.millisecondsSinceEpoch;
      int currentTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

      if (currentTimeMilliseconds - timestampMilliseconds <=
          intervalMilliseconds) {
        return false;
      }
    }

    return true;
  }

  Offset _calculatePositionOfInnerCircle(
      Offset lastPosition, double innerCircleSize, double size, Offset offset) {
    double middle = size / 2.0;

    double angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / _math.pi;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }
    bool isStartPosition = lastPosition.dx == innerCircleSize &&
        lastPosition.dy == innerCircleSize;
    double lastAngleRadians =
        (isStartPosition) ? 0 : (degrees) * (_math.pi / 180.0);

    var rBig = size / 2;
    var rSmall = innerCircleSize / 2;

    var x = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
    var y = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);

    var xPosition = lastPosition.dx - rSmall;
    var yPosition = lastPosition.dy - rSmall;

    var angleRadianPlus = lastAngleRadians + _math.pi / 2;
    if (angleRadianPlus < _math.pi / 2) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < _math.pi) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < 3 * _math.pi / 2) {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    }
    return Offset(xPosition, yPosition);
  }

  DateTime _processGesture(double size, double ignoreSize, Offset offset,
      DateTime callbackTimestamp) {
    double middle = size / 2.0;

    double angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / _math.pi + 90;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }

    double dx = _math.max(0, _math.min(offset.dx, size));
    double dy = _math.max(0, _math.min(offset.dy, size));

    double distance =
        _math.sqrt(_math.pow(middle - dx, 2) + _math.pow(middle - dy, 2));

    double normalizedDistance = _math.min(distance / (size / 2), 1.0);

    DateTime _callbackTimestamp = callbackTimestamp;
    if (onDoubleTab != null && _canCallOnDirectionChanged(callbackTimestamp)) {
      _callbackTimestamp = DateTime.now();
      onDoubleTab!(degrees, normalizedDistance);
    }

    return _callbackTimestamp;
  }
}

class CircleView extends StatelessWidget {
  final double? size;

  final Color? color;

  final List<BoxShadow>? boxShadow;

  final Border? border;

  final double? opacity;

  final Image? buttonImage;

  final Icon? buttonIcon;

  final String? buttonText;

  CircleView({
    this.size,
    this.color = Colors.transparent,
    this.boxShadow,
    this.border,
    this.opacity,
    this.buttonImage,
    this.buttonIcon,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: buttonIcon != null
            ? buttonIcon
            : (buttonImage != null)
                ? buttonImage
                : (buttonText != null)
                    ? Text(buttonText!)
                    : null,
      ),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
    );
  }

  factory CircleView.joystickCircle(double size, Color color) => CircleView(
        size: size,
        color: color,
        border: Border.all(
          color: Colors.black45,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.joystickInnerCircle(double size, Color color) =>
      CircleView(
        size: size,
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.padBackgroundCircle(
          double size, Color backgroundColour, borderColor, Color shadowColor,
          {double? opacity}) =>
      CircleView(
        size: size,
        color: backgroundColour,
        opacity: opacity,
        border: Border.all(
          color: borderColor,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.padButtonCircle(
    double size,
    Color color,
    Image image,
    Icon icon,
    String text,
  ) =>
      CircleView(
        size: size,
        color: color,
        buttonImage: image,
        buttonIcon: icon,
        buttonText: text,
        border: Border.all(
          color: Colors.black26,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );
}
