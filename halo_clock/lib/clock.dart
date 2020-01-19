// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:halo_clock/hour_hand_painter.dart';
import 'package:halo_clock/minute_hand_painter.dart';
import 'package:halo_clock/second_hand_painter.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,

/// A basic analog clock.
///
/// You can do better than this!
class HaloClock extends StatefulWidget {
  const HaloClock(this.model);

  final ClockModel model;

  @override
  _HaloClockState createState() => _HaloClockState();
}

class _HaloClockState extends State<HaloClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(HaloClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF00FF38),
            // Minute hand.
            highlightColor: Color(0xFF8F00FF),
            // Second hand.
            accentColor: Color(0xFF00FFA3),
            backgroundColor: Colors.white,
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFF00FF38),
            // Minute hand.
            highlightColor: Color(0xFF8F00FF),
            // Second hand.
            accentColor: Color(0xFF00FFA3),
            backgroundColor: Colors.black,
          );

    final time = DateTime.now();
    final diameter = MediaQuery.of(context).size.shortestSide * 0.8;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Halo clock with time $time',
        value: time.toString(),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: customTheme.backgroundColor,
              padding: EdgeInsets.all(15.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  alignment: Alignment.center,
                  width: diameter,
                  height: diameter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(diameter),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black38
                                  : Colors.white24,
                          offset: Offset.zero,
                          blurRadius: 10.0,
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black87,
                          offset: Offset.zero,
                          spreadRadius: -5.0,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Container(
                    width: diameter * 0.9,
                    height: diameter * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(diameter),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                            foregroundPainter: HourHandPainter(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              lineColor: customTheme.primaryColor,
                              hour: time.hour,
                              totalHour: widget.model.is24HourFormat ? 24 : 12,
                              width: 18.0,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            foregroundPainter: MinuteHandPainter(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              lineColor: customTheme.highlightColor,
                              width: 10.0,
                              value: time.minute,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            foregroundPainter: SecondHandPainter(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              lineColor: customTheme.accentColor,
                              width: 6.0,
                              value: time.second,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _condition,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                _temperature,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(_location),
            left: 10.0,
            bottom: 10.0,
          )
        ],
      ),
    );
  }
}
