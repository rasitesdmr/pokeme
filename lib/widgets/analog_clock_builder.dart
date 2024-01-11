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
}
