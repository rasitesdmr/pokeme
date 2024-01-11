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
          style: TextStyle(
            color: Colors.white
          ),
        ),
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
    return Stack(
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/roman1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: ClipOval(
            child: SizedBox(
              width: 250,
              height: 250,
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
    );


  }
}
