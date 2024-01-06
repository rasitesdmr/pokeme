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
    return AnalogClock(
      dateTime: DateTime.now(),
      isKeepTime: true,
      markingColor: Colors.red,
      child: const Align(
        alignment: FractionalOffset(0.5, 0.75),
        child: Text('GMT-8'),
      ),
    );
  }

  static Widget buildThirdClock() {
    return AnalogClock(
      dateTime: DateTime.now(),
      isKeepTime: true,
      markingColor: Colors.blue, // Saat işaretlemelerinin rengi.
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Today: ${DateTime.now().toLocal().toString().split(' ')[0]}', // Tarih göstergesi.
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  static Widget buildFourthClock() {
    return AnalogClock(
      dateTime: DateTime.now(),
      isKeepTime: true,
      markingColor: Colors.green, // Saat işaretlemelerinin rengi.
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'GMT-8', // Saat merkezine yerleştirilen özel metin.
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
