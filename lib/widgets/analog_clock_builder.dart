import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class AnalogClockBuilder {
  static Widget buildFirstClock() {
    return AnalogClock(
      dateTime: DateTime.now(),
      isKeepTime: true,
      child: const Align(
        alignment: FractionalOffset(0.5, 0.75),
        child: Text('GMT-8'),
      ),
    );
  }

  static Widget buildSecondClock() {
    return AnalogClock.dark(
      dateTime: DateTime.now(),
      isKeepTime: true,
      markingColor: Colors.white,
      child: const Align(
        alignment: FractionalOffset(0.5, 0.75),
        child: Text(
          'GMT-8',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget buildThirdClock() {
    return AnalogClock(
      child: Stack(
        children: [
          Container(
            width: 285,
            height: 290,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/roman_clock_3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: ClipOval(
              child: SizedBox(
                width: 0,
                height: 0,
                child: AnalogClock(
                  dialColor: null,
                  markingColor: null,
                  hourNumberColor: null,
                  secondHandColor: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFourthClock() {
    return AnalogClock.dark(
      child: Stack(
        children: [
          Container(
            width: 285,
            height: 290,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/roman_clock_black_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: ClipOval(
              child: SizedBox(
                width: 0,
                height: 0,
                child: AnalogClock(
                  dialColor: null,
                  markingColor: null,
                  hourNumberColor: null,
                  secondHandColor: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFifthClock() {
    return AnalogClock.dark(
      child: Stack(
        children: [
          Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/clock_5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: ClipOval(
              child: SizedBox(
                width: 0,
                height: 0,
                child: AnalogClock(
                  dialColor: null,
                  markingColor: null,
                  hourNumberColor: null,
                  secondHandColor: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
